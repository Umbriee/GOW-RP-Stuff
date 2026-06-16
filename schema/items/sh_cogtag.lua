ITEM.name = "COG Tags"
ITEM.description = "A set of some COG-tags. Two sets of metal plates in the shape of gears. They lightly clink and jingle in your hands. They have something engraved onto each of them.\nCOG %s\n%s"
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
	local id = self:GetData("id", "00000")
	local numberleft = string.Left(id,2)
	local numberright = string.Right(id,3)
	local COG = numberleft.."-"..numberright
	local NAME = self:GetData("name", "nobody")
	return string.format(self.description, COG, NAME)
end
