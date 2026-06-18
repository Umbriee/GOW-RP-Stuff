local PLUGIN = PLUGIN

PLUGIN.name			= "Char Create Bodygroups & skins"
PLUGIN.description	= "Edits and changes out the base helix char create body group and skin system with a more users choice one."
PLUGIN.author		= "Umbree"
PLUGIN.schema		= "Any"
PLUGIN.license		= [[
/-------------------------------------------------------------------------------------------------------------------------------------------------------------------\
|														--==| Copyright 2026 Umbree Jones |==--																		|
|	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),				|
|		to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,			|
|			and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:				|
|																																									|
|		--==|| "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software." ||==--				|
|																																									|
|	    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 		|
|  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 	|
|    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.		|
\___________________________________________________________________________________________________________________________________________________________________/
]]

ix.char.RegisterVar("model", {
	field = "model",
	fieldType = ix.type.string,
	default = "models/error.mdl",
	index = 3,
	OnSet = function(character, value, ...)
		local client = character:GetPlayer()
		if (IsValid(client) and client:GetCharacter() == character) then
			client:SetModel(value)
		end

		character.vars.model = value
		error("test",1)
	end,
	OnGet = function(character, default)
		return character.vars.model or default
	end,
	OnDisplay = function(self, container, payload, panel)
		local scroll = container:Add("DScrollPanel")
		scroll:Dock(FILL) -- TODO: don't fill so we can allow other panels
		scroll.Paint = function(panel, width, height)
			derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, Color(255, 255, 255, 25))
		end
		local content = scroll:Add("DPanel")
		content:Dock(FILL)
		content:SetPaintBackground(false)
		content:SetTall(448)
		local layout = content:Add("DIconLayout")
		layout:Dock(TOP)
		layout:SetSpaceX(1)
		layout:SetSpaceY(1)
		layout:SetStretchHeight(true)
		local faction = ix.faction.indices[payload.faction]
		if (faction) then
			local models = faction:GetModels(LocalPlayer())
			for k, v in SortedPairs(models) do
				local icon = layout:Add("SpawnIcon")
				icon:SetSize(64, 128)
				icon:InvalidateLayout(true)
				icon.DoClick = function(this) payload:Set("model", k) end
				icon.PaintOver = function(this, w, h)
					if (payload.model == k) then
						local color = ix.config.Get("color", color_white)
						surface.SetDrawColor(color.r, color.g, color.b, 200)
						for i = 1, 3 do
							local i2 = i * 2
							surface.DrawOutlinedRect(i, i, w - i2, h - i2)
						end
					end
				end
				if (isstring(v)) then
					icon:SetModel(v)
				else
					icon:SetModel(v[1])
				end
			end
		end
		panel.bodygroupcusto = content:Add("DPanel")
		panel.bodygroupcusto:Dock(TOP)
		panel.bodygroupcusto:SetTall(256)
		panel.bodygroupcusto:SetPaintBackground(false)
		return scroll
	end,
	OnValidate = function(self, value, payload, client)
		local faction = ix.faction.indices[payload.faction]
		if (faction) then
			local models = faction:GetModels(client)
			local model = payload.model
			local mdl
			if istable(model) then
				mdl = model[1]
			elseif isnumber(model) then
				mdl = models[model]
			end
			if not mdl then
				return false, "needModel"
			end
		else
			return false, "needModel"
		end
	end,
	OnAdjust = function(self, client, data, value, newData)
		local faction = ix.faction.indices[data.faction]
		if (faction) then
			local model
			if isnumber(value) then
				model = faction:GetModels(client)[value]
			elseif istable(value) then
				model = value
			end
			if (isstring(model)) then
				newData.model = model
			elseif (istable(model)) then
				newData.model = model[1]
				-- save skin/bodygroups to character data
				if model[3] then
					local bodygroups = {}
					for i = 1, #model[3] do
						bodygroups[i - 1] = tonumber(model[3][i]) or 0
					end
				end
				newData.data = newData.data or {}
				
				local skin = model[2] or 0
				local groups = bodygroups or model[3]
				-- newData.model = {[1]=newData.model,[2]=skin,[3]=groups}
				
				newData.data["skin"] = skin
				newData.data["groups"] = groups
			end
		end
	end,
	ShouldDisplay = function(self, container, payload)
		local faction = ix.faction.indices[payload.faction]
		return #faction:GetModels(LocalPlayer()) > 1
	end
})

--[[
if SERVER then
	net.Receive("ixCharacterCreate", function(length, client)
		if ((client.ixNextCharacterCreate or 0) > RealTime()) then
			return
		end

		local maxChars = hook.Run("GetMaxPlayerCharacter", client) or ix.config.Get("maxCharacters", 5)
		local charList = client.ixCharList
		local charCount = table.Count(charList)

		if (charCount >= maxChars) then
			net.Start("ixCharacterAuthFailed")
				net.WriteString("maxCharacters")
				net.WriteTable({})
			net.Send(client)

			return
		end

		client.ixNextCharacterCreate = RealTime() + 1

		local indicies = net.ReadUInt(8)
		local payload = {}

		for _ = 1, indicies do
			payload[net.ReadString()] = net.ReadType()
		end

		local newPayload = {}
		local results = {hook.Run("CanPlayerCreateCharacter", client, payload)}

		if istable(payload.model) then
			local payloadm = payload.model
			local skin = payloadm.skin or payloadm[2]
			local groups = payloadm.groups or payloadm[3]
			payload.model = {[1]=(payloadm.mdl or payloadm[1]),[2]=skin,[3]=groups}
		end
		if (table.remove(results, 1) == false) then
			net.Start("ixCharacterAuthFailed")
				net.WriteString(table.remove(results, 1) or "unknownError")
				net.WriteTable(results)
			net.Send(client)

			return
		end

		for k, _ in pairs(payload) do
			local info = ix.char.vars[k]

			if (!info or (!info.OnValidate and info.bNoDisplay)) then
				payload[k] = nil
			end
		end

		for k, v in SortedPairsByMemberValue(ix.char.vars, "index") do
			local value = payload[k]

			if (v.OnValidate) then
				local result = {v:OnValidate(value, payload, client)}

				if (result[1] == false) then
					local fault = result[2]

					table.remove(result, 2)
					table.remove(result, 1)

					net.Start("ixCharacterAuthFailed")
						net.WriteString(fault)
						net.WriteTable(result)
					net.Send(client)

					return
				else
					if (result[1] != nil) then
						payload[k] = result[1]
					end

					if (v.OnAdjust) then
						v:OnAdjust(client, payload, value, newPayload)
					end
				end
			end
		end

		payload.steamID = client:SteamID64()
		hook.Run("AdjustCreationPayload", client, payload, newPayload)
		payload = table.Merge(payload, newPayload)
		ix.char.Create(payload, function(id)
			if (IsValid(client)) then
				ix.char.loaded[id]:Sync(client)
				net.Start("ixCharacterAuthed")
					net.WriteUInt(id, 32)
					net.WriteUInt(#client.ixCharList, 6)
					for _, v in ipairs(client.ixCharList) do
						net.WriteUInt(v, 32)
					end
				net.Send(client)

				MsgN("Created character '" .. id .. "' for " .. client:SteamName() .. ".")
				hook.Run("OnCharacterCreated", client, ix.char.loaded[id])
			end
		end)
	end)
end
--]]