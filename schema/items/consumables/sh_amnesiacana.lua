ITEM.name = "Union Water"
ITEM.description = "A blue can with a union logo, containing so called refreshing water. It's alright, if a bit bland or bitter."
ITEM.model = Model("models/props_lunk/popcan01a.mdl")
ITEM.skin = 0

ITEM.width			= 1
ITEM.height			= 2

ITEM.open = false
ITEM.typeName = "Drink"
ITEM.actionVerb	= "Drinking"

function ITEM:OnOpen(client, char)
	client:EmitSound("courragateddawn/sfx/items/SodaCan.ogg", 75, 90, 0.5)
end