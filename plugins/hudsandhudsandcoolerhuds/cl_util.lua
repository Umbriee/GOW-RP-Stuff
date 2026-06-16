local PLUGIN = PLUGIN
if CLIENT then
	PLUGIN.scrW = ScrW()
	PLUGIN.scrH = ScrH()
	PLUGIN.BaseWidth = 2048
	PLUGIN.BaseHeight = 1152
	PLUGIN.ratio = (PLUGIN.scrW/PLUGIN.BaseWidth)
	local abs = math.abs -- Store to memory for speeeed
	PLUGIN.ANCHOR_TL	= 0
	PLUGIN.ANCHOR_TR	= 1
	PLUGIN.ANCHOR_BL	= 2
	PLUGIN.ANCHOR_BR	= 3
	PLUGIN.ANCHOR_C	= 4
	function PLUGIN:AnchorPos(x, y, anchor)
		x = x * self.scale
		y = y * self.scale
		if anchor == self.ANCHOR_TR then
			x = self.scrW - x
		elseif anchor == self.ANCHOR_BL then
			y = self.scrH - y
		elseif anchor == self.ANCHOR_BR then
			x = self.scrW - x
			y = self.scrH - y
		elseif anchor == self.ANCHOR_C then
			x = self.scrW * 0.5 + x
			y = self.scrH * 0.5 + y
		end
		return x, y
	end
	function PLUGIN:ScreenPos(x, y, forceanch, posVec)
		if posVec then
			local pos = posVec:ToScreen()
			return math.floor(pos.x), math.floor(pos.y), pos.visible
		end
		local sx = x * self.scale * self.ratio
		local sy = y * self.scale * self.ratio
		if not forceanch then
			if x < 0 then
				sx = self.scrW - abs(sx)
			end
			if y < 0 then
				sy = self.scrH - abs(sy)
			end
		else
			if forceanch == 1 then
				if x < 0 then
					sx = self.scrW - abs(sx)
				end
			elseif forceanch == 2 then
				sx = x * self.ratio
				if y < 0 then
					sy = self.scrH - abs(sy)
				end
			elseif forceanch == 2 then
				sx = x * self.ratio
				sy = y * self.ratio
			end
		end
		return math.floor(sx), math.floor(sy)
	end
	function PLUGIN:ScreenScale(w, h, forceanch)
		-- if not forceanch then
		return math.floor(w * self.ratio * self.scale), math.floor(h * self.ratio * self.scale)
		-- else
		-- 	return math.floor(w * self.ratio), math.floor(h * self.ratio)
		-- end
	end
	local function SetMaterial(mat)
		if mat != nil then
			if type(mat) != "number" then
				surface.SetMaterial(mat)
			else
				surface.SetTexture(mat)
			end
		else
			draw.NoTexture()
		end
	end
	local function SetColor(r,g,b,a)
		surface.SetDrawColor(r or 255, g or 255, b or 255, a or 255)
	end
	PLUGIN.DRAW_ROTATED = 1
	PLUGIN.DRAW_OUTLINE = 2
	PLUGIN.DRAW_ROUNDED = 3
	function PLUGIN:DrawTextRect(index, x,y,w,h, r,g,b,a, forceanch, posVec)
		SetMaterial(index)
		SetColor(r,g,b,a)
		local posx,posy = self:ScreenPos(x, y, forceanch, posVec)
		local posw,posh = self:ScreenScale(w, h)
		surface.DrawTexturedRect(posx, posy, posw, posh)
	end
	function PLUGIN:DrawTextRectRot(index, x,y,w,h, ang, r,g,b,a, posVec)
		SetMaterial(index)
		SetColor(r,g,b,a)
		local posx,posy = self:ScreenPos(x, y, posVec)
		local posw,posh = self:ScreenScale(w, h)
		surface.DrawTexturedRectRotated(posx, posy, posw, posh, ang)
	end
	function PLUGIN:DrawOutlineRect(x,y,w,h, r,g,b,a, t, posVec)
		SetColor(r,g,b,a)
		local posx,posy = self:ScreenPos(x or 1, y or 1, posVec)
		local posw,posh = self:ScreenScale(w or 1, h or 1)
		local post,_	= self:ScreenScale(t or 1, t or 1)
		surface.DrawOutlinedRect(posx, posy, posw, posh, post)
	end
	function PLUGIN:DrawOutlinedRoundedBox(cornerMat, lineMat, x, y, w, h, r, g, b, a, radius)
		x, y = self:ScreenPos(x, y)
		w, h = self:ScreenScale(w, h)
		SetColor(r, g, b, a)
		SetMaterial(cornerMat)
		surface.DrawTexturedRectRotated(
			math.Round(x + radius * 0.5),
			math.Round(y + radius * 0.5),
			radius,
			radius,
			0
		)
		surface.DrawTexturedRectRotated(
			math.Round(x + w - radius * 0.5),
			math.Round(y + radius * 0.5),
			radius,
			radius,
			270
		)
		surface.DrawTexturedRectRotated(
			math.Round(x + w - radius * 0.5),
			math.Round(y + h - radius * 0.5),
			radius,
			radius,
			180
		)
		surface.DrawTexturedRectRotated(
			math.Round(x + radius * 0.5),
			math.Round(y + h - radius * 0.5),
			radius,
			radius,
			90
		)
		SetMaterial(lineMat)
		surface.DrawTexturedRectRotated(
			math.Round(x + (w * 0.5)),
			math.Round(y + (radius * 0.5)),
			math.Round(w - radius * 2),
			radius,
			0
		)
		surface.DrawTexturedRectRotated(
			math.Round(x + (radius * 0.5)),
			math.Round(y + (h * 0.5)),
			math.Round(h - radius * 2),
			radius,
			90
		)
		surface.DrawTexturedRectRotated(
			math.Round(x + (w * 0.5)),
			math.Round(y - (radius * 0.5) + h),
			math.Round(w - radius * 2),
			radius,
			180
		)
		surface.DrawTexturedRectRotated(
			math.Round(x - (radius * 0.5) + w),
			math.Round(y + (h * 0.5)),
			math.Round(h - radius * 2),
			radius,
			270
		)
	end
	function PLUGIN:DrawText(Text, Font, x, y, clr, xalign, yalign, posVec)
		local posx, posy = self:ScreenPos(x, y, posVec)
		local font = Font or "BudgetLabel"
		local color = clr or color_white
		local xalign = xalign or TEXT_ALIGN_LEFT
		local yalign = yalign or TEXT_ALIGN_TOP
		if Text == nil then Text = "LOREM IPSUM" end
		local lines = string.Explode("\n", Text)
		surface.SetFont(font)
		local _, lineHeight = surface.GetTextSize("W") -- Approximate line height
		local totalHeight = #lines * lineHeight
		if yalign == TEXT_ALIGN_CENTER then
			posy = posy - (totalHeight / 2)
		elseif yalign == TEXT_ALIGN_BOTTOM then
			posy = posy - totalHeight
		end
		for i, line in ipairs(lines) do
			draw.SimpleText(line, font, posx, posy + (i - 1) * lineHeight, color, xalign, TEXT_ALIGN_TOP)
		end
	end
	
	local defaultuv = {0,0,1,1}
	function PLUGIN:DrawTextRectUV(index, x,y,w,h, uv, r,g,b,a, forceanch)
		local red,green,blue,alpha = r or 255,g or 255,b or 255,a or 255
		if type(index) == "table" then
			SetMaterial(index.mat)
			red = uv
			green = r
			blue = g
			alpha = b
			forceanch = a
			uv = index.uv
		else
			SetMaterial(index)
			if type(uv) == "number" then
				red = uv
				green = r
				blue = g
				alpha = b
				forceanch = a
				uv = defaultuv
			end
		end
		surface.SetDrawColor(red,green,blue,alpha)
		local uv = uv or {0,0,1,1}
		local posx,posy = self:ScreenPos(x, y, forceanch)
		local posw,posh = self:ScreenScale(w, h, forceanch)
		surface.DrawTexturedRectUV(posx, posy, posw, posh, uv[1], uv[2], uv[3], uv[4])
	end
	function PLUGIN:DrawWithScissor(x, y, w, h, func,forceanch)
		local posx,posy = self:ScreenPos(x, y, forceanch)
		local posw,posh = self:ScreenScale(w, h, forceanch)
		render.SetScissorRect(posx, posy, posx + posw, posy + posh, true)
			func()
		render.SetScissorRect(0, 0, 0, 0, false)
	end
	function PLUGIN:DrawElementWH()
		-- Purposefully Empty function.
	end
	function PLUGIN:GetSpeed(Ent) return Ent:GetVelocity():Length() end
	function PLUGIN:PlayerCam(Player) local weapon = Player:GetActiveWeapon() return IsValid(weapon) and weapon:GetClass() == "gmod_camera" end
	function PLUGIN:StringFind(string, word) return string.find(string, word, 1, true) ~= nil end
	PLUGIN.fontData = {}
	local tempData = {}
	local int = 0
	function PLUGIN:updateFonts()
		local rs = self.scale
		for font,data in pairs(self.fontData) do
			if not data.font or type(data.font) ~= "string" then
				continue
			end
			tempData[font] = {}
			local tmp = tempData[font]
			for key,element in pairs(data) do
				local value = element
				if key == "size" then
					value = value * rs
				end
				tmp[key] = value
			end
			int = int + 1
			surface.CreateFont(font,tmp)
		end
		int = 0
	end
	--==| Proper thanks to DyaMetR[https://steamcommunity.com/id/dyametr] for the original addon and code for their H0L-D4 Hud(Now D/GL4)[https://steamcommunity.com/sharedfiles/filedetails/?id=3459525275] |==--
	function PLUGIN:UpdateCurvedScreen()
		self.curvedpolys = {}
		local div = -1
		local quality = ix.option.Get("hudquality",2)
		local marginf = ix.option.Get("hudmargin",0.2)
		if quality == 5 then
			div = 8
		elseif quality == 4 then
			div = 12
		elseif quality == 3 then
			div = 16
		elseif quality == 2 then
			div = 24
		elseif quality == 1 then
			div = 48
		end
		if div ~= -1 or marginf <= 0 then
			local polycount		= self.scrW / div
			local angle			= 180 / polycount
			local size, margin	= self.scrW / polycount, self.scrH * marginf
			for i=0, polycount do
				local x0, y0 = size * i, margin * math.sin( math.rad( angle * i ) ) / 2
				local x1, y1 = size * ( i + 1 ), margin * math.sin( math.rad( angle * ( i + 1 ) ) ) / 2
				self.curvedpolys[ i + 1 ] = {
					{ x = x0, y = y0, u = x0 / self.scrW, v = 0 },
					{ x = x1, y = y1, u = x1 / self.scrW, v = 0 },
					{ x = x1, y = self.scrH - y1, u = x1 / self.scrW, v = 1 },
					{ x = x0, y = self.scrH - y0, u = x0 / self.scrW, v = 1 }
				}
			end
		else
			self.curvedpolys[1] = {
				{ x=0,y=0,u=0,v=0 },
				{ x=self.scrW,y=0,u=1,v=0 },
				{ x=self.scrW,y=self.scrH,u=1,v=1 },
				{ x=0,y=self.scrH,u=0,v=1 },
				
			}
		end
	end
	function PLUGIN:UpdateScreenData(newW,newH)
		local cvar = ix.option.Get("hudscale",1)
		self.scrW = newW or ScrW()
		self.scrH = newH or ScrH()
	
		self.scaleX = (self.scrW / self.BaseWidth) * cvar
		self.scaleY = (self.scrH / self.BaseHeight) * cvar
	
		self.scale = self.scaleX
	end
	PLUGIN:UpdateScreenData()
	PLUGIN:updateFonts()
	PLUGIN:UpdateCurvedScreen()
	PLUGIN:OnScreenSizeChanged(_,_,newW,newH)
		self:UpdateScreenData(newW,newH)
		self:UpdateCurvedScreen()
		self:updateFonts()
	end

	PLUGIN.HUDRT = nil
	PLUGIN.HUDRTMat = nil
	function PLUGIN:SetupHUD()
		self.HUDRT		= GetRenderTarget('DS-hud-hudrt-'..self.scrW..'-'..self.scrH, self.scrW, self.scrH, false)
		self.HUDRTMat	= CreateMaterial("SimpleHUDMat", "UnlitGeneric", {
			["$basetexture"] = "models/debug/debugwhite",
			["$translucent"] = 1,
			["$color"] = "1 1 1",
			["$alpha"] = 1,
		})
		self.HUDRTMat:SetTexture("$basetexture", self.HUDRT)
	end
	function PLUGIN:preDraw()
		render.PushRenderTarget(self.HUDRT)
		render.Clear(0, 0, 0, 0, true, true)
		cam.Start2D()
	end
	function PLUGIN:postDraw()
		cam.End2D()
		render.PopRenderTarget()
	end
	--[[ 
		-- Here lies some random attempt to add motion movement
		local lastAngFrame = Angle(0, 0, 0)
		local lerpAng = Angle(0, 0, 0)
		local shakeIntensity = 0.05
		local velMagnitude = 0
		local function screenMove()
			local eyang = EyeAngles()
			local velang = (eyang - lastAngFrame) * FrameTime() * 500
			lastAngFrame = eyang
			lerpAng = LerpAngle(shakeIntensity, lerpAng, velang)
			local normX = -(lerpAng.y / 360) * 250 * PLUGIN.scale
			local normY = (lerpAng.p / 360) * 375 * PLUGIN.scale
			local normR = (lerpAng.y / 360) * 15 * PLUGIN.scale
			local val = math.sqrt(velang.p^2 + velang.y^2 + velang.r^2)
			velMagnitude = Lerp(0.01, velMagnitude, val)
			return normX, normY, normR, velMagnitude
		end
		function PLUGIN:DrawFinalHUD()
			surface.SetMaterial(self.HUDRTMat)
			surface.SetDrawColor(255, 255, 255, 255)
			local x, y, r, scaleFactor = screenMove()
			local halfx, halfy = self.scrW * 0.5, self.scrH * 0.5
			surface.DrawTexturedRectRotated(x + halfx,y + halfy,self.scrW * (1 + scaleFactor * 0.001),self.scrH * (1 + scaleFactor * 0.001),r)
		end
	--]]
	function DrawDebugTriangles(poly)
		local count = #poly
		if count < 3 then return end
	
		for i = 2, count - 1 do
			local v1 = poly[1]
			local v2 = poly[i]
			local v3 = poly[i + 1]
	
			local function verttoclr(vert)
				return Color(
					vert.u * 255,
					vert.v * 255,
					128
				)
			end
			local col = verttoclr(poly[1])
			draw.NoTexture()
			surface.SetDrawColor(col)
			surface.DrawLine(v1.x, v1.y, v2.x, v2.y)
			surface.SetDrawColor(verttoclr(poly[i]))
			surface.DrawLine(v2.x, v2.y, v3.x, v3.y)
			surface.SetDrawColor(verttoclr(poly[i+1]))
			surface.DrawLine(v3.x, v3.y, v1.x, v1.y)
			
			draw.SimpleText(
				string.format("u=%.2f v=%.2f", v1.u or 0, v1.v or 0),
				"DermaDefault",
				v1.x,
				v1.y,
				col,
				TEXT_ALIGN_CENTER
			)
	
			draw.SimpleText(
				string.format("u=%.2f v=%.2f", v2.u or 0, v2.v or 0),
				"DermaDefault",
				v2.x,
				v2.y,
				col,
				TEXT_ALIGN_CENTER
			)
	
			draw.SimpleText(
				string.format("u=%.2f v=%.2f", v3.u or 0, v3.v or 0),
				"DermaDefault",
				v3.x,
				v3.y,
				col,
				TEXT_ALIGN_CENTER
			)
			surface.SetDrawColor(color_white)
		end
	end
	function PLUGIN:DrawFinalHUD(qual,marg)
		if not self.HUDRTMat then self:SetupHUD() end
		surface.SetMaterial(self.HUDRTMat)
		surface.SetDrawColor(255,255,255,255)
		if qual <= 0 or marg <= 0 then
			surface.DrawTexturedRect(0, 0, self.scrW, self.scrH)
		elseif self.curvedpolys then
			for i=1, #self.curvedpolys do 
				surface.DrawPoly( self.curvedpolys[ i ] )
			end
			if ix.option.Get("huddebug",false) then
				for i=1, #self.curvedpolys do 
					DrawDebugTriangles(self.curvedpolys[ i ])
				end
			end
		end
	end
else
	-- Server stuff here
end