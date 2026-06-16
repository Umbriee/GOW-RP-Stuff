FACTION.name = "Onyx Guard"
FACTION.description = "Bigger COG Soldiers"
FACTION.color = Color(150, 50, 50, 255)
FACTION.pay = 40
FACTION.models = {
	"models/gearsofwar/players/custom/cog/onyx_guard.mdl",
	"models/gearsofwar/players/custom/cog/female_onyx_guard.mdl"
}
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.runSounds = {[0] = "NPC_CombineS.RunFootstepLeft", [1] = "NPC_CombineS.RunFootstepRight"}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("snubpistol", 1)
	inventory:Add("pistolammo", 2)

	inventory:Add("mk2_lancer", 1)
	inventory:Add("ar2ammo", 2)
	local number = Schema:ZeroNumber(math.random(1, 99999), 5)
	inventory:Add("cogtag",1,{
		id = number,
		name = character:GetName()
	})
	character:SetName("Onyx-RCT "..number.." "..character:GetName())
end

FACTION_OTA = FACTION.index
