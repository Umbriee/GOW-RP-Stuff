local PANEL = {}

PANEL.Deathquotes = {
	"You were never supposed to see this.",
	"You are not the first. You will not be the last.",
	"The next vessel is already waiting.",
	"They do not make mistakes. Only sacrifices.",
	"The world is still standing. That's at least something.",
	"They remember.",
	"This is not the end. Only a transition.",
	"You are now apart of something bigger.",
	"The world continues.",
	"You are never truly gone."
	--"Not a RIFF File [buttons/lightswitch2.wav]"
}

function PANEL:Init()
	local scrW, scrH = ScrW(), ScrH()
	self:SetSize(scrW, scrH)
	self:SetPos(0, 0)

	-- Title Init
	local text = string.utf8upper(L("youreDead"))
	surface.SetFont("ixMenuButtonHugeFont")
	local textW, textH = surface.GetTextSize(text)

	-- Title Draw
	self.label = self:Add("DLabel")
	self.label:SetPaintedManually(true)
	self.label:SetPos(scrW * 0.5 - textW * 0.5, scrH * 0.4 - textH * 0.5)
	self.label:SetFont("ixMenuButtonHugeFont")
	self.label:SetText(text)
	self.label:SetTextColor(Color(255, 50, 50))
	self.label:SizeToContents()

	-- Subtitle Init
	local rand = math.random(#self.Deathquotes)
	local text = string.utf8upper(self.Deathquotes[rand])
	surface.SetFont("ixMenuButtonFont")
	local textW2, textH2 = surface.GetTextSize(text)

	-- Subtitle Draw
	self.subtitle = self:Add("DLabel")
	self.subtitle:SetPaintedManually(true)
	self.subtitle:SetPos(scrW * 0.5 - textW2 * 0.5, scrH * 0.5 - textH2 * 0.5)
	self.subtitle:SetFont("ixMenuButtonFont")
	self.subtitle:SetText(text)
	self.subtitle:SetTextColor(Color(255, 255, 255, 150))
	self.subtitle:SizeToContents()

	self.progress = 0
	surface.PlaySound("gmmp/gow1_stinger_positive04.ogg")
	timer.Simple(1,function()
		if not self then return end
		surface.PlaySound("gmmp/gow1_stinger_positive05.ogg")
	end)
	self:CreateAnimation(ix.config.Get("spawnTime", 5), {
		bIgnoreConfig = true,
		target = {progress = 1},
		OnComplete = function(animation, panel)
			if not panel:IsClosing() then
				panel:Close()
			end
		end
	})

	self.scanlines = {}
	self.particles = {}
	for i = 0, scrH, 20 do
		table.insert(self.scanlines, {
			y = i,
			alpha = math.random(3, 5)
		})
	end
	for i = 1, 15 do
		table.insert(self.particles, {
			x = math.random(0, scrW),
			y = math.random(0, scrH),
			size = math.random(2, 6),
			alpha = math.random(30, 120),
			speed = math.random(50, 100),
			drift = math.random(-30, 30)
		})
	end
end

function PANEL:Think()
	self.label:SetAlpha(math.min(255, self.progress * 510))
	self.subtitle:SetAlpha(math.min(255, (self.progress - 0.3) * 510))
	local function particleReset(particle)
		particle.y		= ScrH()
		particle.x		= math.random(0, ScrW())
		particle.size	= math.random(2, 6)
		particle.alpha	= math.random(30, 120)
		particle.speed	= math.random(50, 100)
		particle.drift	= math.random(-30, 30)
	end
	for _, particle in ipairs(self.particles) do
		local speed = particle.speed * FrameTime()
		local drift = particle.drift * FrameTime()
		particle.y = particle.y - speed
		particle.x = particle.x + drift
		if particle.y < -particle.size then
			particleReset(particle)
		end
		if particle.x < -particle.size or particle.x > (ScrW() + particle.size) then
			particleReset(particle)
		end
	end
end

function PANEL:IsClosing()
	return self.bIsClosing
end

function PANEL:Close()
	self.bIsClosing = true

	timer.Simple(1, function() surface.PlaySound("gmmp/gow1_stinger_positive02.ogg") end)
	self:CreateAnimation(2, {
		index = 3,
		bIgnoreConfig = true,
		target = {progress = 0},
		OnComplete = function(animation, panel)
			panel:Remove()
		end
	})
end

function PANEL:Paint(width, height)
	derma.SkinFunc("PaintDeathScreenBackground", self, width, height, self.progress)
	derma.SkinFunc("PaintDeathScreen", self, width, height, self.progress)
	
	for _, particle in ipairs(self.particles) do
		draw.RoundedBox(particle.size, particle.x, particle.y, particle.size, particle.size, Color(100, 100, 100, particle.alpha * self.progress))
	end
	for _, line in ipairs(self.scanlines) do
		draw.RoundedBox(0, 0, line.y, width, 1, Color(127, 127, 127, line.alpha * self.progress))
	end

	self.label:PaintManual()
	self.subtitle:PaintManual()
end

vgui.Register("ixDeathScreen", PANEL, "Panel")