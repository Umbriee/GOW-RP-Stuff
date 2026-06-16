ITEM.name = "COG Tags"
ITEM.description = "A set of some COG-tags. They lightly clink and jingle in your hands. They have some words engraved onto them.\nID: '%s'\nName: '%s'"
ITEM.model = Model("models/weapons/gow/cog_tags_ms_smesh.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.exRender = true
ITEM.iconCam = {
	pos = Vector(217.35, -168, 682.8),
	ang = Angle(67.92, 140.2, 0),
	fov = 2.24
}

function ITEM:GetDescription()
	return string.format(self.description, self:GetData("id", "00000"), self:GetData("name", "nobody"))
end
