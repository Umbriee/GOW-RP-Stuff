ITEM.name = "Union 'Flavoured' Water"
ITEM.description = "A red can with a union logo, containing so called revitalizing peach flavoured water. Its decent-ish with its flavoring. Though it almost tastes dry."
ITEM.model = Model("models/props_lunk/popcan01a.mdl")
ITEM.skin = 1

ITEM.width			= 1
ITEM.height			= 2

ITEM.open = false
ITEM.typeName = "Drink"
ITEM.actionVerb	= "Drinking"

function ITEM:OnOpen(client, char)
	client:EmitSound("courragateddawn/sfx/items/SodaCan.ogg", 75, 90, 0.5)
end