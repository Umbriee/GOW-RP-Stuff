
local padding = ScreenScale(32)

-- create character panel
DEFINE_BASECLASS("ixCharMenuPanel")
local PANEL = {}

function PANEL:Init()
	local parent = self:GetParent()
	local halfWidth = parent:GetWide() * 0.5 - (padding * 2)
	local halfHeight = parent:GetTall() * 0.5 - (padding * 2)
	local modelFOV = (ScrW() > ScrH() * 1.8) and 100 or 78

	self:ResetPayload(true)

	self.factionButtons = {}
	self.repopulatePanels = {}

	-- faction selection subpanel
	self.factionPanel = self:AddSubpanel("faction", true)
	self.factionPanel:SetTitle("chooseFaction")
	self.factionPanel.OnSetActive = function()
		-- if we only have one faction, we are always selecting that one so we can skip to the description section
		if (#self.factionButtons == 1) then
			self:SetActiveSubpanel("description", 0)
		end
	end

	local modelList = self.factionPanel:Add("Panel")
	modelList:Dock(RIGHT)
	modelList:SetSize(halfWidth + padding * 2, halfHeight)

	local proceed = modelList:Add("ixMenuButton")
	proceed:SetText("proceed")
	proceed:SetContentAlignment(6)
	proceed:Dock(BOTTOM)
	proceed:SizeToContents()
	proceed.DoClick = function()
		self.progress:IncrementProgress()

		self:Populate()
		self:SetActiveSubpanel("description")
	end

	self.factionModel = modelList:Add("ixModelPanel")
	self.factionModel:Dock(FILL)
	self.factionModel:SetModel("models/error.mdl")
	self.factionModel:SetFOV(modelFOV)
	self.factionModel.PaintModel = self.factionModel.Paint

	self.factionButtonsPanel = self.factionPanel:Add("ixCharMenuButtonList")
	self.factionButtonsPanel:SetWide(halfWidth)
	self.factionButtonsPanel:Dock(FILL)

	local factionBack = self.factionPanel:Add("ixMenuButton")
	factionBack:SetText("return")
	factionBack:SizeToContents()
	factionBack:Dock(BOTTOM)
	factionBack.DoClick = function()
		self.progress:DecrementProgress()

		self:SetActiveSubpanel("faction", 0)
		self:SlideDown()

		parent.mainPanel:Undim()
	end

	-- character customization subpanel
	self.description = self:AddSubpanel("description")
	self.description:SetTitle("chooseDescription")

	local descriptionModelList = self.description:Add("Panel")
	descriptionModelList:Dock(LEFT)
	descriptionModelList:SetSize(halfWidth, halfHeight)

	local descriptionBack = descriptionModelList:Add("ixMenuButton")
	descriptionBack:SetText("return")
	descriptionBack:SetContentAlignment(4)
	descriptionBack:SizeToContents()
	descriptionBack:Dock(BOTTOM)
	descriptionBack.DoClick = function()
		self.progress:DecrementProgress()

		if (#self.factionButtons == 1) then
			factionBack:DoClick()
		else
			self:SetActiveSubpanel("faction")
		end
	end

	self.descriptionModel = descriptionModelList:Add("ixModelPanel")
	self.descriptionModel:Dock(FILL)
	self.descriptionModel:SetModel(self.factionModel:GetModel())
	self.descriptionModel:SetFOV(modelFOV - 13)
	self.descriptionModel.PaintModel = self.descriptionModel.Paint

	self.descriptionPanel = self.description:Add("Panel")
	self.descriptionPanel:SetWide(halfWidth + padding * 2)
	self.descriptionPanel:Dock(RIGHT)

	local descriptionProceed = self.descriptionPanel:Add("ixMenuButton")
	descriptionProceed:SetText("proceed")
	descriptionProceed:SetContentAlignment(6)
	descriptionProceed:SizeToContents()
	descriptionProceed:Dock(BOTTOM)
	descriptionProceed.DoClick = function()
		if (self:VerifyProgression("description")) then
			-- there are no panels on the attributes section other than the create button, so we can just create the character
			if (#self.attributesPanel:GetChildren() < 2) then
				self:SendPayload()
				return
			end

			self.progress:IncrementProgress()
			self:SetActiveSubpanel("attributes")
		end
	end

	-- attributes subpanel
	self.attributes = self:AddSubpanel("attributes")
	self.attributes:SetTitle("chooseSkills")

	local attributesModelList = self.attributes:Add("Panel")
	attributesModelList:Dock(LEFT)
	attributesModelList:SetSize(halfWidth, halfHeight)

	local attributesBack = attributesModelList:Add("ixMenuButton")
	attributesBack:SetText("return")
	attributesBack:SetContentAlignment(4)
	attributesBack:SizeToContents()
	attributesBack:Dock(BOTTOM)
	attributesBack.DoClick = function()
		self.progress:DecrementProgress()
		self:SetActiveSubpanel("description")
	end

	self.attributesModel = attributesModelList:Add("ixModelPanel")
	self.attributesModel:Dock(FILL)
	self.attributesModel:SetModel(self.factionModel:GetModel())
	self.attributesModel:SetFOV(modelFOV - 13)
	self.attributesModel.PaintModel = self.attributesModel.Paint

	self.attributesPanel = self.attributes:Add("Panel")
	self.attributesPanel:SetWide(halfWidth + padding * 2)
	self.attributesPanel:Dock(RIGHT)

	local create = self.attributesPanel:Add("ixMenuButton")
	create:SetText("finish")
	create:SetContentAlignment(6)
	create:SizeToContents()
	create:Dock(BOTTOM)
	create.DoClick = function()
		self:SendPayload()
	end

	-- creation progress panel
	self.progress = self:Add("ixSegmentedProgress")
	self.progress:SetBarColor(ix.config.Get("color"))
	self.progress:SetSize(parent:GetWide(), 0)
	self.progress:SizeToContents()
	self.progress:SetPos(0, parent:GetTall() - self.progress:GetTall())

	-- setup payload hooks
	self:AddPayloadHook("model", function(value)
		local faction = ix.faction.indices[self.payload.faction]

		if (faction) then
			local model = faction:GetModels(LocalPlayer())[value]

			self:RedrawModel(model)
		end
	end)

	-- setup character creation hooks
	net.Receive("ixCharacterAuthed", function()
		timer.Remove("ixCharacterCreateTimeout")
		self.awaitingResponse = false

		local id = net.ReadUInt(32)
		local indices = net.ReadUInt(6)
		local charList = {}

		for _ = 1, indices do
			charList[#charList + 1] = net.ReadUInt(32)
		end

		ix.characters = charList

		self:SlideDown()

		if (!IsValid(self) or !IsValid(parent)) then
			return
		end

		if (LocalPlayer():GetCharacter()) then
			parent.mainPanel:Undim()
			parent:ShowNotice(2, L("charCreated"))
		elseif (id) then
			self.bMenuShouldClose = true

			net.Start("ixCharacterChoose")
				net.WriteUInt(id, 32)
			net.SendToServer()
		else
			self:SlideDown()
		end
	end)

	net.Receive("ixCharacterAuthFailed", function()
		timer.Remove("ixCharacterCreateTimeout")
		self.awaitingResponse = false

		local fault = net.ReadString()
		local args = net.ReadTable()

		self:SlideDown()

		parent.mainPanel:Undim()
		parent:ShowNotice(3, L(fault, unpack(args)))
	end)
end
		--==| I'm tired, boss. |==--
	--((Could be better formatted))--
local charset = "0123456789abcdefghijklmnopqrstuvwxyz"
local function EncodeBodygroupValue(value)
	return charset:sub(value + 1, value + 1)
end
local function TableToBodygroupString(groups)
	local highest = 0
	for key,_ in pairs(groups) do
		highest = (key > highest) and key or highest
	end
	local str = ""
	for i = 0,highest do
		local data = EncodeBodygroupValue(groups[i] or 0) 
		str = str..data
	end
	return str
end
function PANEL:RedrawModel(model)
	if not model then error("Attempting to redraw no model?", 1) return end

	if self.bodygroupautodelete then
		for _, pnl in pairs(self.bodygroupautodelete) do
			pnl:Remove()
		end
		self.bodygroupautodelete = nil
	end

	local int = 0
	if self.bodygroupcusto then
		self.bodygroupautodelete = self.bodygroupautodelete or {}
		local parent = self.bodygroupcusto
		local parentwidth = parent:GetWide()
		local width = parentwidth * 0.8 - (padding * 2)

		if istable(model.customskin) then
			local data = model.customskin
			int = int + 1
			local label = parent:Add("DLabel")
				label:SetFont("ixMenuButtonFont")
				label:SetText("Skin:")
				label:SetPos(0, -8)
				label:SetSize(padding * 2, 48)
			self.bodygroupautodelete["bodylabel"] = label
			
			local slider = parent:Add("ixNumSlider")
				slider:SetPos(16 + padding * 2, 0)
				slider:SetSize(width, 32)
					
				slider:SetText("Skin")
				slider:SetMin(data.min or data[1])
				slider:SetMax(data.max or data[2])
				slider:SetDecimals(0)

			local slilabel = slider:GetLabel()
				slilabel:SetText(slider:GetValue())

			local lastskinval
			slider.OnValueUpdated = function(panel)
				local value = math.floor(panel:GetValue())
				if value ~= lastskinval then
					if data.blacklist then
						for _, blacklist in pairs(data.blacklist) do
							if value == blacklist then
								return
							end
						end
					end
					model[2] = value
					self.payload:Set("model", model, true)
					self:UpdateBigModels(model)
					lastskinval = value
				end
			end
			self.bodygroupautodelete["skinslider"] = slider
		end
		if istable(model.customgroups) then
			local label = parent:Add("DLabel")
			label:SetFont("ixMenuButtonFont")
			label:SetText("Bodygroups:")
			label:SetPos(0, -8 + ((int - 1) * 34 + 32))
			label:SetSize(padding * 2, 48)
			self.bodygroupautodelete["bodylabel"] = label
			model[3] = {}
			for groupName, data in pairs(model.customgroups) do
				model[3][data.index] = data.min
			end
			for groupName, data in pairs(model.customgroups) do
				int = int + 1
				local y = (int - 1) * 34 + 32

				local label = parent:Add("DLabel")
					label:SetFont("ixMenuButtonLabelFont")
					label:SetText(groupName)
					label:SetPos(16, y)
					label:SetSize(padding * 2, 32)
					label:SetContentAlignment(4)

				local slider = parent:Add("ixNumSlider")
					slider:SetPos(16 + padding * 2, y)
					slider:SetSize(width, 32)
					slider:SetMin(data.min)
					slider:SetMax(data.max)
					slider:SetDecimals(0)

				local slilabel = slider:GetLabel()
					slilabel:SetText(slider:GetValue())

				local lastvalue
				slider.OnValueUpdated = function(panel)
					local value = math.floor(panel:GetValue())
					if lastvalue ~= value then
						if data.blacklist then
							for _, blocked in ipairs(data.blacklist) do
								if value == blocked then
									return
								end
							end
						end
						model[3][data.index] = value
						self.payload:Set("model", model, true)
						self:UpdateBigModels(model)
						lastvalue = value
					end
				end

				self.bodygroupautodelete[groupName] = slider
				self.bodygroupautodelete[groupName .. "_label"] = label
			end
		end
		parent:SetTall(int * 34 + 32)
	end
	self:UpdateBigModels(model)
end


function PANEL:UpdateBigModels(model)
	if (istable(model)) then
		local skin = model[2] or 0
		local groups = model[3] and TableToBodygroupString(model[3]) or ""
		self.factionModel:SetModel(model[1] or model[1],		skin,	groups)
		self.descriptionModel:SetModel(model[1] or model[1],	skin,	groups)
		self.attributesModel:SetModel(model[1] or model[1],	skin,	groups)
	else
		self.factionModel:SetModel(model)
		self.descriptionModel:SetModel(model)
		self.attributesModel:SetModel(model)
	end
end

function PANEL:SendPayload()
	if (self.awaitingResponse or !self:VerifyProgression()) then
		return
	end

	self.awaitingResponse = true

	timer.Create("ixCharacterCreateTimeout", 10, 1, function()
		if (IsValid(self) and self.awaitingResponse) then
			local parent = self:GetParent()

			self.awaitingResponse = false
			self:SlideDown()

			parent.mainPanel:Undim()
			parent:ShowNotice(3, L("unknownError"))
		end
	end)

	self.payload:Prepare()

	net.Start("ixCharacterCreate")
		net.WriteUInt(table.Count(self.payload), 8)

		for k, v in pairs(self.payload) do
			net.WriteString(k)
			net.WriteType(v)
		end

	net.SendToServer()
end

function PANEL:OnSlideUp()
	self:ResetPayload()
	self:Populate()
	self.progress:SetProgress(1)

	-- the faction subpanel will skip to next subpanel if there is only one faction to choose from,
	-- so we don't have to worry about it here
	self:SetActiveSubpanel("faction", 0)
end

function PANEL:OnSlideDown()
end

function PANEL:ResetPayload(bWithHooks)
	if (bWithHooks) then
		self.hooks = {}
	end

	self.payload = {}

	-- TODO: eh..
	function self.payload.Set(payload, key, value, bDoNotHook)
		self:SetPayload(key, value, bDoNotHook)
	end

	function self.payload.AddHook(payload, key, callback)
		self:AddPayloadHook(key, callback)
	end

	function self.payload.Prepare(payload)
		self.payload.Set = nil
		self.payload.AddHook = nil
		self.payload.Prepare = nil
	end
end

function PANEL:SetPayload(key, value, bDoNotHook)
	self.payload[key] = value
	if not bDoNotHook then
		self:RunPayloadHook(key, value)
	end
end

function PANEL:AddPayloadHook(key, callback)
	if (!self.hooks[key]) then
		self.hooks[key] = {}
	end

	self.hooks[key][#self.hooks[key] + 1] = callback
end

function PANEL:RunPayloadHook(key, value)
	local hooks = self.hooks[key] or {}

	for _, v in ipairs(hooks) do
		v(value)
	end
end

function PANEL:GetContainerPanel(name)
	-- TODO: yuck
	if (name == "description") then
		return self.descriptionPanel
	elseif (name == "attributes") then
		return self.attributesPanel
	end

	return self.descriptionPanel
end

function PANEL:AttachCleanup(panel)
	self.repopulatePanels[#self.repopulatePanels + 1] = panel
end

function PANEL:Populate()
	if (!self.bInitialPopulate) then
		-- setup buttons for the faction panel
		-- TODO: make this a bit less janky
		local lastSelected

		for _, v in pairs(self.factionButtons) do
			if (v:GetSelected()) then
				lastSelected = v.faction
			end

			if (IsValid(v)) then
				v:Remove()
			end
		end

		self.factionButtons = {}

		for _, v in SortedPairs(ix.faction.teams) do
			if (ix.faction.HasWhitelist(v.index)) then
				local button = self.factionButtonsPanel:Add("ixMenuSelectionButton")
				button:SetBackgroundColor(v.color or color_white)
				button:SetText(L(v.name):utf8upper())
				button:SizeToContents()
				button:SetButtonList(self.factionButtons)
				button.faction = v.index
				button.OnSelected = function(panel)
					local faction = ix.faction.indices[panel.faction]
					local models = faction:GetModels(LocalPlayer())

					self.payload:Set("faction", panel.faction)
					self.payload:Set("model", math.random(1, #models))
				end

				if ((lastSelected and lastSelected == v.index) or (!lastSelected and v.isDefault)) then
					button:SetSelected(true)
					lastSelected = v.index
				end
			end
		end
	end

	-- remove panels created for character vars
	for i = 1, #self.repopulatePanels do
		self.repopulatePanels[i]:Remove()
	end

	self.repopulatePanels = {}

	-- payload is empty because we attempted to send it - for whatever reason we're back here again so we need to repopulate
	if (!self.payload.faction) then
		for _, v in pairs(self.factionButtons) do
			if (v:GetSelected()) then
				v:SetSelected(true)
				break
			end
		end
	end

	self.factionButtonsPanel:SizeToContents()

	local zPos = 1

	-- set up character vars
	for k, v in SortedPairsByMemberValue(ix.char.vars, "index") do
		if (!v.bNoDisplay and k != "__SortedIndex") then
			local container = self:GetContainerPanel(v.category or "description")

			if (v.ShouldDisplay and v:ShouldDisplay(container, self.payload) == false) then
				continue
			end

			local panel

			-- if the var has a custom way of displaying, we'll use that instead
			if (v.OnDisplay) then
				panel = v:OnDisplay(container, self.payload, self)
			elseif (isstring(v.default)) then
				panel = container:Add("ixTextEntry")
				panel:Dock(TOP)
				panel:SetFont("ixMenuButtonHugeFont")
				panel:SetUpdateOnType(true)
				panel.OnValueChange = function(this, text)
					self.payload:Set(k, text)
				end
			end

			if (IsValid(panel)) then
				-- add label for entry
				local label = container:Add("DLabel")
				label:SetFont("ixMenuButtonLabelFont")
				label:SetText(L(k):utf8upper())
				label:SizeToContents()
				label:DockMargin(0, 16, 0, 2)
				label:Dock(TOP)

				-- we need to set the docking order so the label is above the panel
				label:SetZPos(zPos - 1)
				panel:SetZPos(zPos)

				self:AttachCleanup(label)
				self:AttachCleanup(panel)

				if (v.OnPostSetup) then
					v:OnPostSetup(panel, self.payload)
				end

				zPos = zPos + 2
			end
		end
	end

	if (!self.bInitialPopulate) then
		-- setup progress bar segments
		if (#self.factionButtons > 1) then
			self.progress:AddSegment("@faction")
		end

		self.progress:AddSegment("@description")

		if (#self.attributesPanel:GetChildren() > 1) then
			self.progress:AddSegment("@skills")
		end

		-- we don't need to show the progress bar if there's only one segment
		if (#self.progress:GetSegments() == 1) then
			self.progress:SetVisible(false)
		end
	end

	self.bInitialPopulate = true
end

function PANEL:VerifyProgression(name)
	for k, v in SortedPairsByMemberValue(ix.char.vars, "index") do
		if (name ~= nil and (v.category or "description") != name) then
			continue
		end

		local value = self.payload[k]

		if (!v.bNoDisplay or v.OnValidate) then
			if (v.OnValidate) then
				local result = {v:OnValidate(value, self.payload, LocalPlayer())}

				if (result[1] == false) then
					self:GetParent():ShowNotice(3, L(unpack(result, 2)))
					return false
				end
			end

			self.payload[k] = value
		end
	end
	return true
end

function PANEL:Paint(width, height)
	derma.SkinFunc("PaintCharacterCreateBackground", self, width, height)
	BaseClass.Paint(self, width, height)
end

vgui.Register("ixCharMenuNew", PANEL, "ixCharMenuPanel")
