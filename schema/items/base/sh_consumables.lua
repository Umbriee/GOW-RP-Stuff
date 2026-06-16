ITEM.name				= "consumables" -- If you want to call this outside of the folder 'consumables', use ITEM.base = "base_consumables". It takes after sh_[consumables].lua or this items 'UID'
ITEM.description		= "A base consumable item. You probably shouldn't see this."
ITEM.model				= Model("models/leak_props/junk/w_garb_popcan2.mdl")
ITEM.skin				= 0
ITEM.width				= 2 -- Commonality to make the food items a bit bigger
ITEM.height				= 2
ITEM.category			= "Consumables"
ITEM.permit				= "consumables"

ITEM.price				= 25

-- Restore values are PER portion. If you want it to be consumed once and gone set maxPortions to 1. --
ITEM.restoreHealth		= 12
ITEM.restoreArmor		= 0

ITEM.restoreStamina		= 0							-- Practically unused.

ITEM.restoreHunger		= 12
ITEM.restoreThirst		= 7
ITEM.restoreToxin		= 0							-- Bit of a misnomer for organization. Gives *back* this amount of toxin. Can be negative to restore.
ITEM.toxinResistance	= 0							-- This is in SECONDS. How long are they able to resist the toxins with a 0.5 multiplier.
ITEM.toxinPermenance	= false						-- Used with toxinResistance to make the user unable to recieve all toxins until their time limit is out.
													-- Internally both values are used by equippable gear for partial or full immunity. Its a bodge, sorry.
													-- Combine also just don't run any functions and are immune right off the get-go.
ITEM.restoreSanity		= 0

--ITEM.itemOnUse		= ""						-- Todo: Upon drinking a soda can, for instance, get a scrappable can.
ITEM.useOnOther			= false						-- Can use on another? Force feed, force heal, etc etc. Will generate another item function only visible when looking at a valid person.
ITEM.useOnOtherDist		= 250						-- How far out use on other can run. 

ITEM.useTime			= 0.5						-- Number Val. How long it takes to  c o n s u m e
ITEM.actionVerb			= "Consuming"				-- The name of the act of using this item. *If* there is use time. 'Consuming ' + 'item.name'

ITEM.typeName			= "Eat"						-- or "Drink", "Inject", etc. Shown as the act to do something in the inv menu.
ITEM.maxPortions		= 4							-- Originally for pills, extended to food
ITEM.portionVerb		= {"Portions","Portion"}	-- Plural vs singular. -- 'There Are/Is [#] Plural/Singular left.'

ITEM.open				= true						-- For rations or cans that start false or closed. Will generate a new action for opening it thats seperated from consumption on false!
ITEM.verbOpen			= "Open"					-- Name for the new action.
ITEM.useOnOpen			= false						-- For it to disapear on open. Say for rations being disgarded on open.

--[[
function ITEM:OnOpen(client, char)					-- Runs as the item is opened. Only available to if ITEM.open is set to false.
	
end
Example for local item files:
ITEM.sound = "items/medshot4.wav"
-- or
ITEM.sound = {
	"items/medshot4.wav",
	"items/medshotno1.wav",
	"items/smallmedkit1.wav"
}
--]]

-- Quite literally all of these below me is honestly just me figuring out what base item functions are since the helix wiki is outdated as hell.
-- And some of these are required for me to re-introduce so things can update in real time for other items under this base.
function ITEM:GetDescription()
	local baseDesc		= self:GetData("description", (self.description or "GetDesc failed."))
	local portionLeft	= self:GetData("portionLeft", self.maxPortions or 4)
	local portionVerb	= self.portionVerb -- use self, not ITEM, in case of inheritance
	local isOpen = self:GetData("open", true)
	if not isOpen then
		baseDesc = baseDesc .. "\n\nIt's sealed shut. Open it first to use!"
	end
	if (portionLeft < (self.maxPortions or 1) && isOpen) then
		local word = (portionLeft == 1) and portionVerb[2] or portionVerb[1]
		return baseDesc .. "\nThere " .. (portionLeft == 1 and "is " or "are ") .. portionLeft .. " " .. word .. " left."
	end

	return baseDesc
end
function ITEM:GetName()
	return self:GetData("name", self.name)
end
function ITEM:GetModel()
	return self:GetData("model", (self.model or "models/leak_props/junk/w_garb_popcan2.mdl"))
end
function ITEM:GetSkin()
	return self:GetData("skin", (self.skin or 0))
end
function ITEM:GetMaterial()
	return nil
end
function ITEM:OnInstanced(index, x, y, item) -- Zero clue what this function does tbh.
	self:SetData("open", self.open)
	self:SetData("useOnOpen", self.useOnOpen)
end
-- Default item functions end here --
function ITEM:PopulateTooltip(tooltip)
	local portionLeft = self:GetData("portionLeft", self.maxPortions or 4)
	local value = "Err"
	local clr1 = Color(0, 120, 230)
	local clr2 = Color(230, 120, 0)
	if (self.restoreHunger or 0) ~= 0 then
		value = (self.restoreHunger or 0)
		local data = tooltip:AddRow("data")
		local clr = clr1
		if value < 0 then
			clr = clr2 
		end
		data:SetBackgroundColor(clr)
		data:SetText("Hunger: ".. value)
		data:SizeToContents()
	end
	if (self.restoreThirst or 0) ~= 0 then
		value = (self.restoreThirst or 0)
		local data = tooltip:AddRow("data")
		local clr = clr1
		if value < 0 then
			clr = clr2 
		end
		data:SetBackgroundColor(clr)
		data:SetText("Thirst: ".. value)
		data:SizeToContents()
	end
	if (self.restoreHealth or 0) ~= 0 then
		value = (self.restoreHealth or 0)
		local data = tooltip:AddRow("data")
		local clr = clr1
		if value < 0 then
			clr = clr2 
		end
		data:SetBackgroundColor(clr)
		data:SetText("Health: ".. value)
		data:SizeToContents()
	end
	if (self.restoreArmor or 0) ~= 0 then
		value = (self.restoreArmor or 0)
		local data = tooltip:AddRow("data")
		local clr = clr1
		if value < 0 then
			clr = clr2 
		end
		data:SetBackgroundColor(clr)
		data:SetText("Armor: ".. value)
		data:SizeToContents()
	end
	if (self.restoreStamina or 0) ~= 0 then
		value = (self.restoreStamina or 0)
		local data = tooltip:AddRow("data")
		local clr = clr1
		if value < 0 then
			clr = clr2 
		end
		data:SetBackgroundColor(clr)
		data:SetText("Stamina: ".. value)
		data:SizeToContents()
	end
	if ix.plugin.Get("sanity") then
		if (self.restoreSanity or 0) ~= 0 then
			value = (self.restoreSanity or 0)
			local data = tooltip:AddRow("data")
			local clr = clr1
			if value < 0 then
				clr = clr2 
			end
			data:SetBackgroundColor(clr)
			data:SetText("Sanity: ".. value)
			data:SizeToContents()
		end
	end
	if (self.restoreToxin or 0) ~= 0 then
		value = (self.restoreToxin or 0)
		local data = tooltip:AddRow("data")
		local clr = clr2
		if value < 0 then
			clr = clr1
		end
		data:SetBackgroundColor(clr)
		data:SetText("Toxins: ".. value)
		data:SizeToContents()
	end
	if (self.toxinResistance or 0) > 0 then
		value = (self.toxinResistance or 0)
		local data = tooltip:AddRow("data")
		local multiplied = " partial "
		if self.toxinPermenance then
			multiplied = " full "
		end
		local formatted = string.FormattedTime(value, "%02i:%02i")
		data:SetBackgroundColor(clr1)
		data:SetText("Toxins"..multiplied.."resistance for ".. formatted .." seconds.")
		data:SizeToContents()
	end
end
function ITEM:getSound(item)
	local defaultSounds = { -- 'Internally' used vars for things already setup.
		Eat = "npc/barnacle/barnacle_crunch2.wav",
		Drink = "npc/barnacle/barnacle_gulp2.wav",
		Use = "courragateddawn/sfx/items/medkit_pickup.ogg",
		Bandage = "courragateddawn/sfx/items/bandage_use.ogg",
		["Take One"] = {
			"courragateddawn/sfx/items/pilltakesound_1.ogg",
			"courragateddawn/sfx/items/pilltakesound_2.ogg"
		}
	}

	local customSound = item.sound
	if istable(customSound) and #customSound > 0 then
		return customSound[math.random(#customSound)]
	elseif isstring(customSound) then
		return customSound
	end

	local default = defaultSounds[item.typeName]
	if istable(default) and #default > 0 then
		return default[math.random(#default)]
	elseif isstring(default) then
		return default
	end

	return "npc/barnacle/barnacle_tongue_pull1.wav" -- Fallback fallback
end
function ITEM:OnConsume(target,item,timered)
	if target:IsPlayer() && item then
		local char = target:GetCharacter()
		if not char then return false end
		if not IsValid(target) then return false end
		local healthRestore = (item.restoreHealth or 0)
		if healthRestore ~= 0 then
			local hp = target:Health()
			local maxHP = math.max(target:GetMaxHealth(), hp) -- I do it this way so if you have 400 over your 100 max hp then it stays at 400.
			local restoreVal = math.Clamp(hp + healthRestore, 0, maxHP)
			if restoreVal <= 0 then -- DIE. --
				target:Kill()
				target:Notify("You overdosed on "..item.name.."!")
			else
				target:SetHealth(restoreVal)
			end
		end
		local shieldRestore = (item.restoreArmor or 0)
		if shieldRestore ~= 0 then
			local shield = target:Armor()
			local shieldMax = math.max(target:GetMaxArmor(), shield) -- Same reason give or take.
			local restoreVal = math.Clamp(shield + shieldRestore, 1, shieldMax) 
			target:SetArmor(restoreVal)
		end
		if ix.plugin.Get("survival_system") then
			local hungerRestore = (item.restoreHunger or 0)
			if hungerRestore ~= 0 then
				local currHunger = char:GetData("hunger", 100)
				local restoreVal = math.Clamp(currHunger + hungerRestore, 0, 100)
				target:SetHunger(restoreVal)
			end

			local thirstRestore = (item.restoreThirst or 0)
			if thirstRestore ~= 0 then
				local currThirst = char:GetData("thirst", 100)
				local restoreVal = math.Clamp(currThirst + thirstRestore, 0, 100)
				target:SetThirst(restoreVal)
			end
			local restoreToxin = (item.restoreToxin or 0)
			if restoreToxin ~= 0 then
				local currToxin = char:GetData("toxin", 100)
				local restoreVal = math.Clamp(currToxin + restoreToxin, 0, 100)
				target:SetToxin(restoreVal)
			end
			local toxinResistance = (item.toxinResistance or 0)
			if toxinResistance ~= 0 then
				local currToxin = char:GetData("toxin", 100)
				local toxinPermenance = (item.toxinPermenance or false)
				if toxinPermenance then
					target:SetNetVar("toxinProtection", CurTime() + toxinResistance)
					target:SetLocalVar("toxinProtection", CurTime() + toxinResistance)
				else
					target:SetNetVar("toxinResistance", CurTime() + toxinResistance)
					target:SetLocalVar("toxinResistance", CurTime() + toxinResistance)
				end
			end
		end

		local staminaRestore = (item.restoreStamina or 0)
		if staminaRestore ~= 0 then
			target:RestoreStamina(staminaRestore)
		end
		local restoreSanity = (item.restoreSanity or 0)
		if ix.plugin.Get("sanity") then
			if restoreSanity ~= 0 then
				char:AddSanity(restoreSanity)
				local s = char.GetSanity and char:GetSanity() or nil
				if s ~= nil then
					target:SetLocalVar("sanity", s)
					target:SetNetVar("sanityPublic", s)
				end
			end
		end

		target:EmitSound(item:getSound(item), 75, 90, 0.35)
		local data = item:GetData("portionLeft", item.maxPortions or 4)
		if data <= 1 then
			item:Remove()
		else
			item:SetData("portionLeft", data - 1)
		end
	end
end
function ITEM:PaintOver(item, w, h)
	local portionLeft = item:GetData("portionLeft", item.maxPortions or 4)
	local maxPortions = item.maxPortions or 4
	local frac = math.Clamp(portionLeft / maxPortions, 0, 1)
	local frac2 = (1 - frac)

	local barWidth = 8
	local barMargin = 14
	local barHeight = h - (barMargin * 2)

	local fillHeight = barHeight * frac

	local x = w - barMargin - barWidth
	local y = h - barMargin - fillHeight

	if (portionLeft < maxPortions) then
		surface.SetDrawColor(50, 50, 50, 150)
		surface.DrawRect(x, barMargin, barWidth, barHeight)

		surface.SetDrawColor((frac2 * 255), (frac * 255), 0, 150)
		surface.DrawRect(x, y, barWidth, fillHeight)
		draw.SimpleTextOutlined((portionLeft.."/"..maxPortions),"DermaDefault",x+(barWidth*0.5),(h * 0.5),Color(255,100,0,150),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(50,50,50,150))
	end
end

function ITEM:OnRegistered()
	self.functions = self.functions or {}
	-- Friendly code refresh for stuff I made. Gods I hate reconnecting... I have to do so anyways for any functions than self.functions .v. fml
	for k, v in pairs(self.functions) do
		if v._isDynamicAction then
			self.functions[k] = nil
		end
	end

	if not self.typeName or type(self.typeName) != "string" then
		return
	end
	
	self.functions.open = {
		name = (ITEM.verbOpen.." "..self.name),
		tip = (ITEM.verbOpen.." the " .. self.name .. "."),
		_isDynamicAction = true,
		OnCanRun = function(item)
			return (item:GetData("open",true) == false)
		end,
		OnRun = function(item)
			local client = item.player
			local char = client:GetCharacter()
			if item.OnOpen then
				item:OnOpen(client, char)
			end
			item:SetData("open", true)
			
			return item:GetData("useOnOpen",false) == true
		end		
	}
	self.functions[self.typeName] = {
		name = self.typeName,
		tip = self.typeName .. " the " .. self.name .. ".",
		_isDynamicAction = true,
		OnCanRun = function(item)
			return (item:GetData("open", true) == true)
		end,		
		OnRun = function(item)
			local client = item.player
			local char = client:GetCharacter()
			local result = false
			if ( item.useTime && item.actionVerb) then
				client:SetAction((item.actionVerb.." "..item.name), item.useTime, function()
					item:OnConsume(client,item,true)
				end)
			else
				result = item:OnConsume(client,item,false)
			end
			return false
		end
	}
	if self.useOnOther == true then
		self.functions[self.typeName.."Other"] = {
			name = "Force "..self.typeName.." on other",
			tip = "Force another to "..self.typeName .. " the " .. self.name .. ".",
			_isDynamicAction = true,
	
			OnCanRun = function(item)
				local client = item.player
				local ent = client:GetEyeTrace().Entity
				if ((ent:IsValid()) && (item:GetData("open",true) == true)) then -- Lotta checks. Damn.
					if client:GetPos():Distance(ent:GetPos()) < (item.useOnOtherDist or 250) then
						if ent:IsPlayer() then 
							return true 
						else 
							return false 
						end
					else
						return false 
					end
				else
					return false 
				end
			end,
			OnRun = function(item)
				local client = item.player
				local ent = client:GetEyeTrace().Entity
				if ent:IsPlayer() then
					if ( item.useTime && item.actionVerb) then
						client:Notify("You begin to force "..ent:Nick().." to "..item.typeName.." the "..item.name)
						ent:Notify(client:Nick().." is trying to use the "..item.name.." onto you!")
						client:SetAction((item.actionVerb.." "..item.name), item.useTime, function()
							local ent2 = client:GetEyeTrace().Entity
							if client:GetPos():Distance(ent2:GetPos()) < (item.useOnOtherDist or 250) then
								if ent == ent2 then
									item:OnConsume(ent,item,true)
									client:Notify("You force "..ent:Nick().." to "..item.typeName.." the "..item.name)
									ent:Notify(client:Nick().." used the "..item.name.." on you!")
								else
									client:Notify("Target moved or is not in your line of sight!")
								end
							else
								client:Notify("Target moved or is not in your line of sight!")
							end
						end)
					else
						item:OnConsume(ent,item,false)
						client:Notify("You force "..ent:Nick().." to "..item.typeName.." the "..item.name)
						ent:Notify(client:Nick().." used the "..item.name.." on you!")
					end
				else
					client:Notify("You are not looking at a valid person.")
				end
				return false
			end
		}
	end

	-- Another attempt at friendly code refreshing. I am unsure if this even works.
	for _, v in pairs(ix.item.list) do
        if v.base == self.uniqueID then
            for k, f in pairs(self) do
                if isfunction(f) and not v[k] then
                    v[k] = f
					print("Refreshed item")
                end
            end
        end
    end
end