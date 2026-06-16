ITEM.name = "Union 'Sparkling' Water"
ITEM.description = "A bright yellow can with a Union stamp on it's surface, containing bubbling sparkling water. Despite not stating it on the label it tastes like a sour lemonade. Too much lemon.."
ITEM.model = Model("models/props_lunk/popcan01a.mdl")
ITEM.skin = 2

ITEM.width			= 1
ITEM.height			= 2

ITEM.open = false
ITEM.typeName = "Drink"
ITEM.actionVerb	= "Drinking"

function ITEM:OnOpen(client, char)
	client:EmitSound("courragateddawn/sfx/items/SodaCan.ogg", 75, 90, 0.35)
end