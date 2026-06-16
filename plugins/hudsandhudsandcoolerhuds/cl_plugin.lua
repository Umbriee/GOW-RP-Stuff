local PLUGIN = PLUGIN

function PLUGIN:HudDraw()
	if self:PlayerCam(LocalPlayer()) then return end

	local client = LocalPlayer()
	local char = client:GetCharacter()

	if not client or not char then return end

	local hideBarsPriority = 0
	local ammoHUDPriority = 0

	for _, huddata in pairs(self.huddrawdata) do
		local can = true

		if isfunction(huddata.onCanDraw) then
			can = huddata.onCanDraw(self, client, char)
		end

		if not can then
			continue
		end

		if isfunction(huddata.onHudDraw) then
			huddata.onHudDraw(self, client, char)
		end
		if huddata.hideBars then
			local priority = huddata.hideBarsPriority or 1

			if priority > hideBarsPriority then
				hideBarsPriority = priority
			end
		end
		if huddata.hideAmmoHUD then
			local priority = huddata.ammoHUDPriority or 1

			if priority > ammoHUDPriority then
				ammoHUDPriority = priority
			end
		end
	end
	self.bHideBars = hideBarsPriority > 0
	self.bDrawAmmoHud = ammoHUDPriority <= 0
end

function PLUGIN:CanDrawAmmoHUD(weapon)
	return self.bDrawAmmoHud ~= false
end

function PLUGIN:ShouldHideBars()
	return self.bHideBars == true
end
function PLUGIN:UpdateTime()
	self.ActualFrameTime = math.max(FrameTime(),self.configTime)
end
function PLUGIN:DrawTime()
	return self.ActualFrameTime or FrameTime()
end
function PLUGIN:HUDPaint()
	self.configTime = (ix.option.Get("hudtime",200) / 1000)
	self.quality = ix.option.Get("hudquality",2)
	self.margin = ix.option.Get("hudmargin",0.2)
	local scale = ix.option.Get("hudscale",1)
	if (nextDraw or 0) <= CurTime() then
		if self.quality ~= lastqal or self.margin ~= lastmarg or lastscale ~= scale then
			self:UpdateCurvedScreen()
			self:UpdateScreenData()
			lastqal		= self.quality
			lastmarg	= self.margin
			lastscale	= scale
		end
		self:preDraw()
			self:UpdateTime()
			self:HudDraw()
		self:postDraw()
		nextDraw = CurTime() + self.configTime
	end
	self:DrawFinalHUD(self.quality,self.margin)
end