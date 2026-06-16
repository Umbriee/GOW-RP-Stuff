
local PANEL = {}

local vignette = ix.util.GetMaterial("helix/gui/vignette.png")

local function WrapText(text, font, maxWidth)
    surface.SetFont(font)

    local lines = {}
    local words = string.Explode(" ", text)

    local currentLine = ""
    for _, word in ipairs(words) do
        local wordWidth = surface.GetTextSize(word)

        if surface.GetTextSize(currentLine .. " " .. word) <= maxWidth then
            currentLine = currentLine .. " " .. word
        else
            table.insert(lines, currentLine)
            currentLine = word
        end
    end

    if currentLine ~= "" then
        table.insert(lines, currentLine)
    end

    return table.concat(lines, "\n")
end

function PANEL:Init()
	self:SetSize(ScrW(), ScrH())
	self:Center()
	self:ShowCloseButton(false)
	self:MakePopup()
	self:SetCursor("blank")

	self.canClose = false
	
	timer.Simple(2, function()
		self.canClose = true
	end)
	
	LocalPlayer().ixItemInspector = self
end

function PANEL:Populate(itemModel, itemSkin, itemName, itemDescription)
	local itemModelPanel = vgui.Create("DAdjustableModelPanel", self)
	itemModelPanel:SetSize(ScrW(), ScrH())
	itemModelPanel:Center()
	itemModelPanel:SetModel(itemModel)
	itemModelPanel:GetEntity():SetSkin(itemSkin)
	itemModelPanel:SetLookAt(Vector(0, 0, 0))
	itemModelPanel:SetCursor("blank")

	function itemModelPanel:LayoutEntity(entity) return end

	local entity = itemModelPanel:GetEntity()
	local pos = entity:GetPos()
	local camPos = pos + Vector(0, 200, 0)
	
	itemModelPanel:SetCamPos(camPos)
	itemModelPanel:SetFOV(30)
	itemModelPanel:SetLookAng((camPos * -1):Angle())

	itemModelPanel:OnMousePressed(MOUSE_LEFT)
	
	function itemModelPanel:OnMousePressed() end
	function itemModelPanel:OnMouseReleased() end

	function itemModelPanel:Think()
		if (input.IsKeyDown(KEY_E) and LocalPlayer().ixItemInspector.canClose) then
			LocalPlayer().ixItemInspector:Close()
			LocalPlayer().ixItemInspector = nil
		end

		if (!self.Capturing) then return end

		if (self.m_bFirstPerson) then
			return self:FirstPersonControls()
		end
	end

	local newItemText = vgui.Create("DPanel", self)
	newItemText:Dock(TOP)
	newItemText:SetHeight(150)

	function newItemText:Paint(width, height)
		draw.DrawText("New item discovered:", "ixMenuButtonHugeFont", width / 2, height / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end

	local itemNameDesc = vgui.Create("DPanel", self)
	itemNameDesc:Dock(BOTTOM)
	itemNameDesc:SetHeight(300)
	local maxWidthItemDesc = ScrH() + ( ScrH() / 2)

	local itemWrapDescription = WrapText(itemDescription, "ixMenuButtonFont", maxWidthItemDesc)

	function itemNameDesc:Paint(width, height)
		draw.DrawText(itemName, "ixSubTitleFont", width / 2, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		draw.DrawText(itemWrapDescription, "ixMenuButtonFont", width / 2, 50, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		
		draw.DrawText("[E] Continue", "ixBigFont", width / 2, 200, Color(255, 255, 255, math.abs(math.sin(CurTime())) * 200), TEXT_ALIGN_CENTER)
	end
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.SetMaterial(vignette)
	surface.DrawTexturedRect(0, 0, width, height)
	
	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(0, 0, width, height)
end

vgui.Register("ixItemInspector", PANEL, "DFrame")
