local PLUGIN = PLUGIN

util.AddNetworkString("umco_voxlistreq")
function tfavox_swapper_getlist()
	return PLUGIN.voxtable
end
function PLUGIN:VoxReqList(_, ply, iMode, tonew, tocopy)
	if not SERVER then return "Err, Not server space!" end
	if TFAVOX_Models and ply:IsValid() and ply:IsPlayer() and ply:IsAdmin() then
		local function tfa_reload()
			TFAVOX_Packs_Initialize()
			--==| Here be dragons. I cannot do what EhPMS does and shove their script under the 'tfa_vox/packs/' so it gets loaded during that loop -- So I'm gonna just hope this works! |==--
			local tbl
			if tfavox_swapper_getlist and isfunction(tfavox_swapper_getlist) then tbl = tfavox_swapper_getlist() end
			if istable(tbl) then
				for k, v in pairs(tbl) do
					TFAVOX_Models[k] = TFAVOX_Models[v]
				end
			end
			--==|                                                                                                                                                                         |==--
			TFAVOX_PrecachePacks()
			for k,v in pairs(player.GetAll()) do
				print("Resetting the VOX of " .. v:Nick())
				if IsValid(v) then TFAVOX_Init(v,true,true) end
			end
		end
		local mode = iMode
		if mode == 1 then
			local k = tonew
			local v = tocopy
			self.voxtable[k] = v
			self:SaveVox()
			tfa_reload()
		elseif mode == 2 then
			local tbl = tonew
			if istable(tbl) then
				for k, v in pairs(tbl) do
					local name = tostring(v)
					self.voxtable[name] = nil
					if istable(TFAVOX_Models) then TFAVOX_Models[name] = nil end
				end
				self:SaveVox()
				tfa_reload()
			end
		end
	end
end