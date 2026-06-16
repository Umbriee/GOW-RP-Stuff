FACTION.name = "Union of Independent Republics"
FACTION.description = "MEEE IMUULSION"
FACTION.color = Color(255, 200, 100, 255)
FACTION.pay = 50
FACTION.models = {
	"models/gearsofwar/players/custom/uir/uir_trooper_ue.mdl",
	"models/gearsofwar/players/custom/uir/uir_female_trooper_ue.mdl",
	"models/gearsofwar/players/custom/cog/cog_template2.mdl",
	"models/gearsofwar/players/custom/cog/cog_template3.mdl"
}
FACTION.isDefault = false
FACTION.isGloballyRecognized = true

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("snubpistol", 1)
	inventory:Add("pistolammo", 2)
	local number = Schema:ZeroNumber(math.random(1, 99999), 5)
	character:SetName("UIR-RCT "..number.." "..character:GetName())
end

FACTION_UIR = FACTION.index
