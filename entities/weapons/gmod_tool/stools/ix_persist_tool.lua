local PERSIST_PLUGIN = PERSIST_PLUGIN or ix.plugin.Get("persistence")

if not PERSIST_PLUGIN then
	hook.Add("ixPersistenceReady", "ixPersistTool_Bind", function(plugin)
		if not plugin or not plugin.stored then return end
		if not PERSIST_PLUGIN then
			print("[PersistTool] - PersistTool Hook has been ran.")
			if plugin.DummyVar == 1337 then
				local dataIndexes = 0
				for _, v in ipairs(plugin.stored) do dataIndexes = dataIndexes + 1 end
				print("[PersistTool] - The plugin is confirmed working with "..dataIndexes.." stored data")
				plugin.DummyVar = nil
				PERSIST_PLUGIN = plugin
				hook.Remove("ixPersistenceReady", "ixPersistTool_Bind")
			else
				print("[PersistTool] - Dummy Var came back negative. Tool is broken.")
			end
		else
			print("[PersistTool] - Tool reports already having the Plugin Saved")
		end
	end)
else
	print("[PersistTool] - Tool reports already having the Plugin. No bridge hook created.")
end
local mode = TOOL.Mode
TOOL.Mode = "ix_persist_tool"
TOOL.Category = "Persistence"
TOOL.Name = "#ix Persist Tool"

TOOL.ClientConVar["radius"] = "200"
TOOL.ClientConVar["area_radius"] = "200"
TOOL.ClientConVar["filter_persisted"] = "1"
TOOL.ClientConVar["filter_unpersisted"] = "1"
TOOL.ClientConVar["filter_map_props"] = "1"
TOOL.ClientConVar["forceworld"] = "0"
TOOL.ClientConVar["ignore_z"] = "0"

local function isValidTarget(ent, ply)
	if not IsValid(ent) then return false end
	if ent:IsPlayer() or ent:IsWeapon() or ent:IsNPC() or ent:IsNextBot() then return false end
	if ent:GetMoveType() == MOVETYPE_NONE and not ent:GetModel() then return false end
	if ent:GetSolid() <= 0 then return false end

	local cls = ent:GetClass()
	if cls:match("^env_") or cls:match("^logic_") or cls:match("^beam") then return false end

	local mdl = ent:GetModel()
	if not mdl or not util.IsValidModel(mdl) then return false end

	-- Don't allow world props to be persisted unless forceworld is enabled
	local forceWorld = ply:GetInfoNum(mode.."_forceworld", 0) == 1
	if not forceWorld and (ent:MapCreationID() > 0 or ent:CreatedByMap()) then return false end

	local alreadyPersisted = ent:GetNetVar("Persistent")

	return true
end
local function isWorld(ent)
	if (ent:MapCreationID() > 0) then return true end
	return false
end
local function attemptPersistChange(ent, ply, bool)
	local filterPersist = ply:GetInfoNum(mode.."_filter_persisted", 0) == 0
	local filterUnpersist = ply:GetInfoNum(mode.."_filter_unpersisted", 0) == 0
	local filterMap = ply:GetInfoNum(mode.."_filter_map", 0) == 1
	if CLIENT then
		if not PERSIST_PLUGIN or not PERSIST_PLUGIN.stored then
			print("[Persist Tool] - ERR: Persistence plugin not found or not initialized.")
			return end
	else
		if not PERSIST_PLUGIN or not PERSIST_PLUGIN.stored then
			print("[Persist Tool] - ERR: Persistence plugin not found or not initialized.")
			return
		end
		if filterPersist and ent:GetNetVar("Persistent") == true then return end
		if filterUnpersist and ent:GetNetVar("Persistent") == false then return end
		if filterMap and (ent:CreatedByMap() or ent:MapCreationID() > 0) then return end

		local was = ent:GetNetVar("Persistent")
		if was ~= bool then
			ent:SetNetVar("Persistent", bool)
			ix.log.Add(ply, "persist", ent:GetModel(), bool)

			if bool then
				-- Add to PERSIST_PLUGIN.stored if not already there
				for _, v in ipairs(PERSIST_PLUGIN.stored) do
					if v == ent then return end
				end
				table.insert(PERSIST_PLUGIN.stored, ent)
			else
				-- Remove from PERSIST_PLUGIN.stored
				for k, v in ipairs(PERSIST_PLUGIN.stored) do
					if v == ent then
						table.remove(PERSIST_PLUGIN.stored, k)
						break
					end
				end
			end
		end
	end
end
local function DoAreaAffect(self, ply, pos, radius, persist)
	for _, ent in ipairs(ents.FindInSphere(pos, radius)) do
		if isValidTarget(ent, ply) then
			if SERVER then
				attemptPersistChange(ent,ply,persist)
			end
		end
	end
end
function TOOL:LeftClick(trace)
	local ply = self:GetOwner()

	if ply:KeyDown(IN_USE) then
		local radius = self:GetClientNumber("area_radius", 200)
		DoAreaAffect(self, ply, trace.HitPos, radius, true)
	else
		local ent = trace.Entity
		if not isValidTarget(ent, ply) then return false end

		attemptPersistChange(ent,ply,true)
	end

	return true
end

function TOOL:RightClick(trace)
	local ply = self:GetOwner()

	if ply:KeyDown(IN_USE) then
		local radius = self:GetClientNumber("area_radius", 200)
		DoAreaAffect(self, ply, trace.HitPos, radius, false)
	else
		local ent = trace.Entity
		if not isValidTarget(ent, ply) then return false end

		attemptPersistChange(ent,ply,false)
	end

	return true
end
function TOOL:Reload(trace) -- Dunno. --
	if CLIENT then
	end
	return false
end

-- Draw overlays
if CLIENT then
	language.Add("tool.ix_persist_tool.name", "ix Persist Tool")
	language.Add("tool.ix_persist_tool.desc", "Toggle persistence for props")
	language.Add("tool.ix_persist_tool.left", "Left Click: Persist")
	language.Add("tool.ix_persist_tool.right", "Right Click: Unpersist")
	language.Add("tool.ix_persist_tool.reload", "Reload: Toggle Filter")

	language.Add("tool.ix_persist_tool.0", "Attack1 to persist. Attack2 to unpersist. Hold USE to area persist with m1/m2")

	-- hook.Remove("PostDrawTranslucentRenderables", "ixPersistTool_Overlay")
	hook.Add("PostDrawTranslucentRenderables", "ixPersistTool_Overlay", function()
		local ply = LocalPlayer()
		if not ply:Alive() then return end

		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) or wep:GetClass() ~= "gmod_tool" then return end

		local tool = ply:GetTool()
		if not tool or tool.Mode ~= "ix_persist_tool" then return end

		local radius = ply:GetInfoNum(mode.."_radius", 200)
		local areaRadius = ply:GetInfoNum(mode.."_area_radius", 200)
		local filterPersisted = ply:GetInfoNum(mode.."_filter_persisted", 1) == 1
		local filterUnpersisted = ply:GetInfoNum(mode.."_filter_unpersisted", 1) == 1
		local filterMapProps = ply:GetInfoNum(mode.."_filter_map_props", 1) == 1
		local ignoreZ  = (ply:GetInfoNum(mode.."_ignore_z", 0) == 1) or false

		local colorPersist = Color(0, 255, 0)
		local colorUnpersist = Color(255, 0, 0)
		local colorMap = Color(255, 0, 255)

		for _, ent in ipairs(ents.FindInSphere(ply:GetPos(), radius)) do
			if not isValidTarget(ent, ply) then continue end

			local persistent = ent:GetNetVar("Persistent", false)
			local isMapProp = ent:MapCreationID() > 0

			local color = isMapProp and colorMap or (persistent and colorPersist or colorUnpersist)
			if persistent and not filterPersisted then continue end
			if not persistent and not filterUnpersisted then continue end
			if isMapProp and not filterMapProps then continue end

			local dist = ply:GetPos():Distance(ent:GetPos())
			local alpha = 255 - math.Clamp(dist, 0, radius) / radius * 200
			color.a = alpha

			cam.Start3D()
			cam.IgnoreZ(ignoreZ)
			render.SetColorMaterial()
			render.DrawWireframeBox(ent:GetPos(), ent:GetAngles(), ent:OBBMins(), ent:OBBMaxs(), color, true)
			cam.End3D()
		end

		if ply:KeyDown(IN_USE) then
			local trace = ply:GetEyeTrace()
			local pos = trace.HitPos
			cam.Start3D()
			render.SetColorMaterial()
			render.DrawWireframeSphere(pos, areaRadius, 32, 32, Color(0, 200, 255, 150), true)
			cam.End3D()
		end
	end)
end

-- Tool panel UI
function TOOL.BuildCPanel(panel)
	panel:AddControl("Header", { Description = "Toggle persistence on props, individually or in an area." })
	panel:NumSlider("Visual Cull beyond:", mode.."_radius", 25, 1080, 0)
	panel:NumSlider("Range Persist Radius", mode.."_area_radius", 25, 512, 0)
	panel:CheckBox("Ignore Z Depth", mode.."_ignore_z")
	panel:Help("")
	panel:Help("--filters--")
	panel:CheckBox("Show Persisted Props", mode.."_filter_persisted")
	panel:CheckBox("Show Unpersisted Props", mode.."_filter_unpersisted")
	panel:CheckBox("Show Map Props", mode.."_filter_map_props")
	panel:Help("")
	panel:Help("Forces persist from .bsp spawned items. Only use if you know what you're doing.")
	panel:CheckBox("Force Persist World", mode.."_forceworld")
end