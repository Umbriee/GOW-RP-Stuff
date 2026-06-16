local PLUGIN = PLUGIN

function PLUGIN:HudDraw()
	if self:PlayerCam(LocalPlayer()) then return end
	local client, char = LocalPlayer(),LocalPlayer():GetCharacter()
	if not IsValid(client) or not IsValid(char) then return end
	for key, drawfunc in pairs(self.huddrawdata) do
		local can = true
		if drawfunc.onCanDraw and isfunction(drawfunc.onCanDraw) then
			local onCanDraw = drawfunc.onCanDraw
			can = onCanDraw(self,client, char)
		end
		if can and isfunction(drawfunc.onHudDraw) then
			drawfunc.onHudDraw(self,client,char)
		else
			continue
		end
	end
end

function PLUGIN:HUDPaint()
	local drawtime = (ix.option.Get("hudtime",200) / 1000)
	local quality = ix.option.Get("hudquality",2)
	local margin = ix.option.Get("hudmargin",0.2)
	if (nextDraw or 0) <= CurTime() then
		if quality ~= lastqal or margin ~= lastmarg then
			self:UpdateCurvedScreen()
			lastqal		= quality
			lastmarg	= margin
		end
		self:preDraw()
			self:HudDraw()
		self:postDraw()
		nextDraw = CurTime() + drawtime
	end
	self:DrawFinalHUD(quality,margin)
end