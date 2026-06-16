local PLUGIN = PLUGIN

PLUGIN.name = "Voice Menu"
PLUGIN.author = "Umbree"
PLUGIN.description = "Fast voice line selector & editor."

PLUGIN.bind = KEY_B

if CLIENT then

	-- Kindly; FUCK OFF. --
	hook.Remove("PlayerButtonDown", "VoiceRadialOpen")
	hook.Remove("PlayerButtonUp", "VoiceRadialClose")
	hook.Remove("HUDPaint", "VoiceRadialPaint") -- More so for my constant lua refresh and having to deal with hooks remaining sometimes. Its odd.

	--==[ Constants & Globals ]==--
	local quickSlots = quickSlots or {}
	local quickCategories = { [1] = "Full List" }
	local totalSegments = 1

	local segmentOffset = 0

	local rotationOffset = 0

	local isOpen = false
	local centerX, centerY = 0,0
	local ratioX,ratioY = (2048/ScrW()),(1152/ScrH())
	local radius, lineWidth = 150, 50

	PLUGIN.classPanels = PLUGIN.classPanels or {} -- This feels bad to do. Oh well!
	--==[ UTIL ]==--
	local function GetAllowedVoiceClasses()
		local allowed = {}
		for classID, classData in pairs(Schema.voices.classes) do
			if classData.condition(LocalPlayer()) and Schema.voices.stored[classID] then
				table.insert(allowed, classID)
			end
		end
		return allowed
	end
	local function GetPlayerFactionAndClassKey()
		local ply = LocalPlayer()
		if not ply or not ply:GetCharacter() then return nil, nil end

		local faction = team.GetName(ply:Team()) or "nofaction"

		local classID = ply:GetCharacter():GetClass()
		local classData = classID and ix.class.Get(classID)
		local classKey = classData and classData.uniqueID or "noclass"

		return faction, classKey
	end
	--==[ SaveToFile ]==--
	local function GetQuickSlotsForCurrentPlayer()
		local faction, classKey = GetPlayerFactionAndClassKey()
		if not faction or not classKey then return nil end
	
		quickSlots[faction] = quickSlots[faction] or {}
		quickSlots[faction][classKey] = quickSlots[faction][classKey] or {}
	
		return quickSlots[faction][classKey]
	end
	
	function RebuildQuickCategories()
		local fallbackDefaults = { "Contact", "Pain", "Banter", "Affirm", "Decline" }

		local faction, classKey = GetPlayerFactionAndClassKey()
		if not faction or not classKey then return end

		local classData = quickSlots[faction] and quickSlots[faction][classKey]
		classData = classData or {}

		local newCategories = { "Full List" }
		local catSet = { ["Full List"] = true }

		local found = false

		for catName, lines in pairs(classData) do
			if istable(lines) and not catSet[catName] then
				table.insert(newCategories, catName)
				catSet[catName] = true
				if #lines > 0 then
					found = true
				end
			end
		end

		if not found then
			for _, defCat in ipairs(fallbackDefaults) do
				classData[defCat] = classData[defCat] or {}
				if not catSet[defCat] then
					table.insert(newCategories, defCat)
					catSet[defCat] = true
				end
			end
		end

		quickCategories = newCategories
		totalSegments = #quickCategories
	end
	local function PruneEmptyCategories()
		for faction, factionData in pairs(quickSlots) do
			for classID, classData in pairs(factionData) do
				for catName, catData in pairs(classData) do
					if #catData == 0 then
						classData[catName] = nil
					end
				end
			end
		end
	end
	local function SaveQuickSlots()
		local faction, classKey = GetPlayerFactionAndClassKey()
		if not faction or not classKey then return end
		file.CreateDir("helix")
		local fullPath = "helix/ix_voicemenusave.json"
		local data = {}
		if file.Exists(fullPath, "DATA") then
			data = util.JSONToTable(file.Read(fullPath, "DATA")) or {}
		end
		quickSlots[faction] = quickSlots[faction] or {}
		quickSlots[faction][classKey] = quickSlots[faction][classKey] or {}
		data[faction] = data[faction] or {}
		data[faction][classKey] = table.Copy(quickSlots[faction][classKey])
		file.Write(fullPath, util.TableToJSON(data, true))
		RebuildQuickCategories()
	end
	
	local function LoadQuickSlots()
		local faction, classKey = GetPlayerFactionAndClassKey()
		if not faction or not classKey then return end
	
		local fullPath = "helix/ix_voicemenusave.json"
	
		-- Load entire file once
		if file.Exists(fullPath, "DATA") then
			local data = util.JSONToTable(file.Read(fullPath, "DATA")) or {}
			quickSlots = data
		else
			quickSlots = {}
		end
	
		-- Ensure current faction/class table exists
		quickSlots[faction] = quickSlots[faction] or {}
		quickSlots[faction][classKey] = quickSlots[faction][classKey] or {}
	
		RebuildQuickCategories()
	end
	
	local hasVoiceSynced = false
	function PLUGIN:CharacterLoaded(character)
		--print("New char.")
		local client = character:GetPlayer()
		if (IsValid(client)) then
			if LocalPlayer() == client then
				LoadQuickSlots()
				--print("Is local? Yes.")
			end
		end
	end
	--==[ VG-UI ]==--
	local function OpenVoiceConfigMenu(classID, command)
		local frame = vgui.Create("DFrame")
		frame:SetSize(300 * ratioX, 400 * ratioY)
		frame:Center()
		frame:SetTitle("Configure: " .. command)
		frame:MakePopup()

		local ply = LocalPlayer()
		local faction, classKey = GetPlayerFactionAndClassKey()
		local classDataTable = quickSlots[faction] and quickSlots[faction][classKey]

		local function UpdateButtonStates()
			for _, cat in ipairs(quickCategories) do
				local btn = frame[ "assignBtn_" .. cat ]
				if not btn then continue end
				local assigned = classDataTable and classDataTable[cat] and table.HasValue(classDataTable[cat], command)
				local label = "Assign to " .. cat
				if assigned then
					label = label .. "  [Assigned]"
					btn:SetTextColor(Color(100, 255, 100)) -- Green!
				else
					btn:SetTextColor(color_white)
				end
				btn:SetText(label)
			end
		end

		for _, category in ipairs(quickCategories) do
			if category == "Full List" then continue end

			local btn = frame:Add("DButton")
			btn:Dock(TOP)
			btn:DockMargin(5, 5, 5, 0)
			btn:SetText("Assign to " .. category)

			btn.DoClick = function()
				local classDataTable = GetQuickSlotsForCurrentPlayer()
				if not classDataTable then return end

				classDataTable[category] = classDataTable[category] or {}

				if not table.HasValue(classDataTable[category], command) then
					table.insert(classDataTable[category], command)
					LocalPlayer():Notify("Assigned to '" .. category .. "'")
				else
					for i, cmd in ipairs(classDataTable[category]) do
						if cmd == command then
							table.remove(classDataTable[category], i)
							break
						end
					end
					LocalPlayer():Notify("Removed from '" .. category .. "'")
				end

				SaveQuickSlots()
				UpdateButtonStates()
				frame:Close()
			end
		end
		UpdateButtonStates()

		local sep = frame:Add("DPanel")
		sep:SetTall(2)
		sep:Dock(TOP)
		sep:DockMargin(5, 15, 5, 15)
		sep.Paint = function(self, w, h)
			surface.SetDrawColor(100, 100, 100, 180)
			surface.DrawRect(0, 0, w, h)
		end

		local catLabel = vgui.Create("DLabel", frame)
		catLabel:Dock(TOP)
		catLabel:DockMargin(5, 0, 5, 5)
		catLabel:SetText("Manage Categories")
		catLabel:SetFont("DermaDefaultBold")
		catLabel:SetColor(color_white)

		local catScroll = vgui.Create("DScrollPanel", frame)
		catScroll:Dock(FILL)
		catScroll:DockMargin(5, 0, 5, 5)

		local function RefreshCategoryList()
			catScroll:Clear()
			for _, cat in ipairs(quickCategories) do
				if cat ~= "Full List" then
					local panel = catScroll:Add("DPanel")
					panel:Dock(TOP)
					panel:SetTall(30)
					panel:DockMargin(0, 0, 0, 5)

					local catNameLabel = vgui.Create("DLabel", panel)
					catNameLabel:SetText(cat)
					catNameLabel:Dock(LEFT)
					catNameLabel:DockMargin(5, 5, 10, 5)
					catNameLabel:SetWide(150)
					catNameLabel:SetColor(color_white)

					local renameBtn = vgui.Create("DButton", panel)
					renameBtn:SetText("Rename")
					renameBtn:Dock(LEFT)
					renameBtn:SetWide(60)
					renameBtn:DockMargin(0, 5, 5, 5)
					renameBtn.DoClick = function()
						Derma_StringRequest(
							"Rename Category",
							"New name for '" .. cat .. "':",
							cat,
							function(newName)
								if newName == "" or newName == "Full List" then
									LocalPlayer():Notify("Invalid category name.")
									return
								end
								for faction, factionData in pairs(quickSlots) do
									for classID, classData in pairs(factionData) do
										if classData[cat] then
											classData[newName] = classData[newName] or {}
											for _, v in ipairs(classData[cat]) do
												table.insert(classData[newName], v)
											end
											classData[cat] = nil
										end
									end
								end
								for i, v in ipairs(quickCategories) do
									if v == "Full List" then continue end
									if v == cat then
										quickCategories[i] = newName
									end
								end


								RebuildQuickCategories()
								SaveQuickSlots()
								LocalPlayer():Notify("Category renamed to '" .. newName .. "'")
								RefreshCategoryList()
							end,
							function() end
						)
					end

					local deleteBtn = vgui.Create("DButton", panel)
					deleteBtn:SetText("Delete")
					deleteBtn:Dock(LEFT)
					deleteBtn:SetWide(60)
					deleteBtn:DockMargin(0, 5, 5, 5)
					deleteBtn.DoClick = function()
						Derma_Query(
							"Delete category '" .. cat .. "'? This removes it from all data.",
							"Confirm Delete",
							"Delete",
							function()
								for faction, factionData in pairs(quickSlots) do
									for classID, classData in pairs(factionData) do
										if classData[cat] then
											classData[cat] = nil
										end
									end
								end
								for i, v in ipairs(quickCategories) do
									if v == "Full List" then continue end
									if v == cat then
										table.remove(quickCategories, i)
										break
									end
								end
								RebuildQuickCategories()
								SaveQuickSlots()
								LocalPlayer():Notify("Category '" .. cat .. "' deleted.")
								RefreshCategoryList()
							end,
							"Cancel",
							function() end
						)
					end
				end
			end
		end

		RefreshCategoryList()

		local addCatBtn = vgui.Create("DButton", frame)
		addCatBtn:Dock(BOTTOM)
		addCatBtn:DockMargin(5, 5, 5, 5)
		addCatBtn:SetText("Create New Category")
		addCatBtn.DoClick = function()
			Derma_StringRequest(
				"New Category",
				"Enter new category name:",
				"",
				function(newCat)
					if newCat == "" or newCat == "Full List" then
						LocalPlayer():Notify("Invalid category name.")
						return
					end
					table.insert(quickCategories, newCat)
					for faction, factionData in pairs(quickSlots) do
						for classID, classData in pairs(factionData) do
							classData[newCat] = classData[newCat] or {}
						end
					end
					RebuildQuickCategories()
					SaveQuickSlots()
					LocalPlayer():Notify("Category '" .. newCat .. "' created.")
					RefreshCategoryList()
				end,
				function() end
			)
		end
	end
	local function OpenFullListMenu()
		local allowedClasses = GetAllowedVoiceClasses()
		if #allowedClasses < 1 then return end

		local frame = vgui.Create("DFrame")
		frame:SetSize(400 * ratioX, 500 * ratioY)
		frame:Center()
		frame:SetTitle("Voice Lines")
		frame:MakePopup()
		gui.EnableScreenClicker(true)

		local searchBar
		PLUGIN.classPanels = {}
		local classPanels = PLUGIN.classPanels
		local shiftDown, ctrlDown, altDown = false, false, false
		local lastSearchText = ""

		local main = frame:Add("DPanel")
		main:Dock(FILL)
		main:DockMargin(5, 5, 5, 5)

		searchBar = vgui.Create("DTextEntry", main)
		searchBar:Dock(TOP)
		searchBar:SetPlaceholderText("Search voice lines...")

		local scroll = vgui.Create("DScrollPanel", main)
		scroll:Dock(FILL)

		frame.Think = function()
			local currentText = searchBar:GetText():lower()
			if currentText ~= lastSearchText then
				lastSearchText = currentText

				local ply = LocalPlayer()
				local faction, classKey = GetPlayerFactionAndClassKey()

				for classID, data in pairs(classPanels) do
					local foundInGroup = false

					for _, entry in ipairs(data.buttons) do
						local cmdMatch = string.find(entry.cmd:lower(), currentText, 1, true)

						local categoryMatch = false
						if quickSlots[faction] and quickSlots[faction][classKey] then
							for category, cmds in pairs(quickSlots[faction][classKey]) do
								if string.find(category:lower(), currentText, 1, true) and table.HasValue(cmds, entry.cmd) then
									categoryMatch = true
									break
								end
							end
						end

						local visible = cmdMatch or categoryMatch
						entry.button:SetVisible(visible) -- 436
						if visible then
							foundInGroup = true
						end
					end

					data.panel:SetVisible(foundInGroup)
					data.content:InvalidateLayout()
				end
			end
			shiftDown = input.IsKeyDown( KEY_LSHIFT )
			ctrlDown = input.IsKeyDown( KEY_LCONTROL )
			altDown = input.IsKeyDown( KEY_LALT )
		end
		frame.OnRemove = function()
			gui.EnableScreenClicker(false)
		end

		for _, classID in ipairs(allowedClasses) do
			local lines = Schema.voices.stored[classID]
			if not lines then continue end

			local category = vgui.Create("DCollapsibleCategory", scroll)
			category:SetLabel(classID:upper())
			category:Dock(TOP)
			category:DockMargin(0, 5, 0, 0)

			local listPanel = vgui.Create("DPanel", category)
			listPanel:SetTall(1)
			listPanel:Dock(TOP)
			listPanel.Paint = nil

			listPanel.PerformLayout = function(self)
				local totalHeight = 0
				for _, child in ipairs(self:GetChildren()) do
					if child:IsVisible() then
						totalHeight = totalHeight + child:GetTall() + 2
					end
				end
				self:SetTall(totalHeight)
			end

			category:SetContents(listPanel)

			classPanels[classID] = {
				panel = category,
				content = listPanel,
				buttons = {}
			}

			for cmd, _ in SortedPairs(lines) do
				local btn = vgui.Create("DButton", listPanel)
				btn:SetText(cmd:upper())
				btn:SetTall(24)
				btn:Dock(TOP)
				btn:DockMargin(10, 2, 10, 2)

				btn.DoClick = function()
					local finalCmd = cmd
					if shiftDown then
						finalCmd = "/y " .. cmd
					elseif ctrlDown then
						finalCmd = "/w " .. cmd
					elseif altDown then
						finalCmd = "/r " .. cmd
					end

					RunConsoleCommand("say", finalCmd)
					frame:Close()
				end

				btn.DoRightClick = function()
					OpenVoiceConfigMenu(classID, cmd)
				end

				table.insert(classPanels[classID].buttons, {
					cmd = cmd,
					button = btn
				})
				local ply = LocalPlayer()
				local faction, classKey = GetPlayerFactionAndClassKey()
				local assignedCategories = {}
				if quickSlots[faction] and quickSlots[faction][classKey] then
					for category, cmds in pairs(quickSlots[faction][classKey]) do
						if table.HasValue(cmds, cmd) then
							table.insert(assignedCategories, category)
						end
					end
				end
				local label = cmd:upper()
				if #assignedCategories > 0 then
					label = label .. "  [" .. table.concat(assignedCategories, ", ") .. "]"
					btn:SetTextColor(Color(100, 255, 100))
				else
					btn:SetTextColor(color_white)
				end
				btn:SetText(label)
			end
		end
	end
	--==[ LOGIC: Fire Random Quick Line ]==--
	local function FireRandomQuickLine(category)
		local faction, classKey = GetPlayerFactionAndClassKey()
		if not faction or not classKey then return false end
		local pool = {}
		local categories = quickSlots[faction] and quickSlots[faction][classKey]
		if categories and categories[category] then
			for _, cmd in ipairs(categories[category]) do
				table.insert(pool, cmd)
			end
		end
		if #pool < 1 then
			print("[QuickLine] No entries for category:", category)
			return false
		end
		local chosen = pool[math.random(#pool)]
		local mode = ""
		if input.IsKeyDown(KEY_LSHIFT) or input.IsKeyDown(KEY_RSHIFT) then
			mode = "/y "
		elseif input.IsKeyDown(KEY_LCONTROL) or input.IsKeyDown(KEY_RCONTROL) then
			mode = "/w "
		elseif input.IsKeyDown(KEY_LALT) or input.IsKeyDown(KEY_RALT) then
			mode = "/radio "
		end
		RunConsoleCommand("say", mode .. chosen)
		return true
	end	
	--==[ HUD-UI ]==--
	local function fnArc( x, y, radius, linewidth, startangle, endangle, aa )
		aa = math.abs( aa )
		local arc = {}
		local pass = 1
		local inner = {}
		local outer = {}
		local diff = math.abs( startangle - endangle )
		local smoothness = math.log( diff, 2 ) * 0.5
		local step = diff * ( 1 / math.pow( aa, smoothness ) )
		if ( startangle > endangle ) then
			step = math.abs( step ) * -1
		end
		local offset = 1 / aa
		for i = startangle, endangle, step do
			local angle = math.rad( i )
			local aSin, aCos = math.sin( angle ), math.cos( angle )
			local r = radius - linewidth
			local ox, oy = x + ( aSin * r ), y + ( -aCos * r )
			inner[pass] = {
				x=ox,
				y=oy,
				u=(ox-x)/radius + offset,
				v=(oy-y)/radius + offset,
			}
			local ox2, oy2 = x + ( aSin * radius ), y + ( -aCos * radius )
			outer[pass] = {
				x=ox2,
				y=oy2,
				u=(ox2-x)/radius + offset,
				v=(oy2-y)/radius + offset,
			}
			pass = pass + 1
		end
		for node = 1, pass do
			local p1, p2, p3, p4
			local forward = node + 1
			p1 = outer[node]
			p2 = outer[forward]
			p3 = inner[forward]
			p4 = inner[node]
			arc[node] = { p1, p2, p3, p4 }
		end
				draw.NoTexture()
		for k,v in pairs( arc ) do
			surface.DrawPoly( v )
		end
	end
	local function GetMouseAngle(mx, my)
		local dx, dy = mx - centerX, my - centerY
		local angle = math.deg(math.atan2(dy, dx))
		angle = (angle + 90) % 360
		return angle
	end
	local function GetSelectedSegment(mx, my)
		local dx, dy = mx - centerX, my - centerY
		local dist = math.sqrt(dx * dx + dy * dy)
		if dist < radius * 0.4 then return nil end

		local angle = GetMouseAngle(mx, my)
		local seg = math.floor(angle / (360 / totalSegments)) + 1
		if seg < 1 then seg = 1 end
		if seg > totalSegments then seg = totalSegments end
		return seg or -1
	end
	local function GetOffsetSegment(i)
		local newIndex = ((i + segmentOffset) % totalSegments)
		return newIndex
	end

	local function GetLabel(i)
		return ((i == 1) and "Full List" or (quickCategories[i] or "ERR")) or "NIL"
	end
	local openTime = 0
	local radialAlpha = 0
	local lastSelectedSegment = -1
	local function DrawRadial()
		-- if not isOpen then return end
		local targetAlpha = isOpen and 255 or 0
		radialAlpha = Lerp(FrameTime() * 10, radialAlpha, targetAlpha)
		if radialAlpha < 1 then return end
		local mx, my = gui.MousePos()
		local selected = (GetSelectedSegment(mx, my) or -1) + 0
		local anglePer = 360 / totalSegments
		

		-- Debug prints
		local ang = GetMouseAngle(mx, my)
		local seg = selected
		-- draw.SimpleText("Angle: " .. math.floor(ang), "DermaDefault", 10, 10, color_white)
		-- draw.SimpleText("Selected segment: " .. seg, "DermaDefault", 10, 30, color_white)
		-- draw.SimpleText("Mouse: " .. mx .. ", " .. my, "DermaDefault", 10, 50, color_white)

		-- Center dot
		-- surface.SetDrawColor(255, 0, 0)
		-- surface.DrawRect(centerX - 2, centerY - 2, 4, 4)

		for i = 1, (totalSegments) do
			-- print("i = "..i)
			if i == 0 then continue end -- I don't know what to do man. I am suffering at perfection.
			local segIndex = GetOffsetSegment(i)
			local startAng = (((segIndex - 1) * anglePer) - anglePer)
			local endAng = (((segIndex) * anglePer) - anglePer)

			local isSelected = (i == selected)
			-- if i == 1 then col = Color(140, 140, 140, 180) end
			local col = isSelected and Color(120, 120, 255, radialAlpha * 0.67) or Color(120, 120, 120, radialAlpha * 0.2)
			-- if i == 0 then
			surface.SetDrawColor(col)
			fnArc(centerX, centerY, radius, lineWidth, startAng + anglePer, endAng + anglePer, 3)
			-- end

			local midAngle = (i - 2) * anglePer
			local midRad = math.rad(midAngle)
			
			local textRadius = (radius - lineWidth) * (1.25 * 2048/ScrW())
			local tx = centerX + math.cos(midRad) * textRadius
			local ty = centerY + math.sin(midRad) * textRadius
			draw.SimpleTextOutlined(
				GetLabel(i), 
				"DermaDefaultBold", 
				tx, ty, 
				Color(255, 255, 255, radialAlpha), 
				TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 
				1, Color(0, 0, 0, radialAlpha * 0.8)
			)
			-- surface.SetDrawColor(0, 255, 0, 180)
			-- local angleRad = math.rad(((segIndex) * anglePer) + 90)
			-- surface.DrawLine(centerX, centerY, centerX + math.cos(angleRad) * radius, centerY + math.sin(angleRad) * radius)
		end
		if selected ~= lastSelectedSegment and selected ~= -1 then
			surface.PlaySound("UI/buttonrollover.wav") -- use a subtle local sound
		end
		lastSelectedSegment = selected
		-- surface.SetDrawColor(255, 255, 0)
		-- surface.DrawRect(mx - 2, my - 2, 4, 4)
	end
	hook.Add("PlayerButtonDown", "VoiceRadialOpen", function(ply, button) -- ARR ME MATEY. AND ME LEFT HOOK.
		if ply ~= LocalPlayer() then return end
		if ply:GetCharacter() then else return end
		if button ~= PLUGIN.bind then return end

		if LocalPlayer():IsTyping() or gui.IsGameUIVisible() then return end
		if isOpen then return end

		centerX, centerY = ScrW() / 2, ScrH() / 2
		gui.EnableScreenClicker(true)
		isOpen = true
		openTime = CurTime()
		radialAlpha = 0
		--print("[Radial] Opened")
	end)
	hook.Add("PlayerButtonUp", "VoiceRadialClose", function(ply, button)
		if ply ~= LocalPlayer() then return end
		if ply:GetCharacter() then else return end
		if button ~= PLUGIN.bind then return end

		if not isOpen then return end

		local mx, my = gui.MousePos()
		local selected = GetSelectedSegment(mx, my)

		isOpen = false
		gui.EnableScreenClicker(false)

		--print("[Radial] Closed - mx: "..mx.." my: "..my)

		if not selected then return end
		if selected == 1 then
			--print("[Radial] Selected: Full List")
			OpenFullListMenu()
		else
			local category = quickCategories[selected]
			if category then
				--print("[Radial] Selected Quick Category: '"..category.."'")
				FireRandomQuickLine(category)
			else
				print("[Radial] Wtf. Something went wrong. #"..selected.." doesn't have a category?") -- Shouldn't ever happen.. Hopefully.
			end
		end
		surface.PlaySound("ui/buttonclickrelease.wav")
	end)
	hook.Add("HUDPaint", "VoiceRadialPaint", function()
		DrawRadial()
	end)
else
	-- The server can have a little bit of space here :)
	-- For further context I'm doing random stuff to keep myself sane in the form of writing comments. Have fun reading.
end