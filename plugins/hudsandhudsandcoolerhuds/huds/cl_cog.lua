local PLUGIN = PLUGIN

if CLIENT then
	local huddraw = {}
	local smoothaddative = "smooth additive noclamp"
	huddraw.mats = {
		siegehorde1bg = {mat = Material("gowrp/gow3/Warfare_HUD/Siege_Horde_TimerTokens.png",smoothaddative), uv = {0,0.171875,0.75,0.2890625}},
		siegehorde1fg = {mat = Material("gowrp/gow3/Warfare_HUD/Siege_Horde_TimerTokens.png",smoothaddative), uv = {0,0.4921875,0.75,0.6328125}}
	}
	--[[
		[6]:
		["GetValue"]	=	function: 0x80880afe9eaf6ca2
		["color"]:
				["a"]	=	255
				["b"]	=	101
				["g"]	=	149
				["r"]	=	101
		["identifier"]	=	toxin
		["index"]	=	6
		["panel"]	=	Panel: [name:ixInfoBar][class:Panel][0,0,716,10]
		["priority"]	=	6
	]]
	function huddraw:DrawStatuses(client,char)
		self.savedata = self.savedata or {}
		local int = 0
		for i, data in pairs(ix.bar.list) do
			self.savedata[data.identifier] = self.savedata[data.identifier] or {}
			local sd = self.savedata[data.identifier]
			local value = 1
			local txt = ""
			if isfunction(data.GetValue) then
				local fnc = data.GetValue
				value,txt = fnc()
			end
			if value > 0 then
				int = int + 1
				local y = 32 + ((int-1) * 42)
				local x = 32 + ((int-1) * 3)
				sd.smoothedvalue = Lerp(PLUGIN:DrawTime() * 3,sd.smoothedvalue or 0,value)
				PLUGIN:DrawTextRectUV(self.mats.siegehorde1bg, x,y,256,32, 255,255,255,data.color.a)
				PLUGIN:DrawText((data.identifier..": "..math.Round(value*100).."%"..(txt and " "..tostring(txt) or "")), nil, x, y, data.color)
				PLUGIN:DrawTextRectUV(self.mats.siegehorde1fg, x,y+16,256,16, data.color.r*0.25,data.color.g*0.25,data.color.b*0.25,data.color.a)
				PLUGIN:DrawWithScissor(x, y, 256*sd.smoothedvalue, 32, function()
					PLUGIN:DrawTextRectUV(self.mats.siegehorde1fg, x,y+16,256,16, data.color.r,data.color.g,data.color.b,data.color.a)
				end)
			end
		end
	end
	function huddraw:DrawHud(client,char)
		-- print(self,client,char)
		if client:Alive() then
			self:DrawStatuses(client,char)
		end
	end
	

	PLUGIN.huddrawdata = PLUGIN.huddrawdata or {}
	PLUGIN.huddrawdata["cog"] = PLUGIN.huddrawdata["cog"] or {}
	local drawdata = PLUGIN.huddrawdata["cog"] or {}
	drawdata.onHudDraw = function(_, client, char)
		huddraw:DrawHud(client,char)
	end
	drawdata.onCanDraw = function(_, client, char)
		return client:IsCOG()
	end
	drawdata.hideAmmoHUD = true
	drawdata.ammoHUDPriority = 1
	drawdata.hideBars = true
	drawdata.hideBarsPriority = 1
else

end