ITEM.name			= "Blank Business Permit"
ITEM.description	= "An RFID chip used in the permission of purchasing goods."
ITEM.model			= "models/n7/props/n7_cid_card.mdl"
ITEM.skin = 5
ITEM.iconCam = {
	pos	= Vector(1, 3, 22),
	ang	= Angle(82.1, -120.1, 0),
	fov	= 35,
}

ITEM.price			= 100
ITEM.category		= "Permits"
ITEM.permit			= "Permits"

function ITEM:GetDescription()
	return self.description
end
function ITEM:GetName()
	return self.name
end
function ITEM:GetSkin()
	return self.skin
end

function ITEM:GetModel()
	self.iconCam = {
		pos = Vector(456.37, 424.22, 1304.01),
		ang = Angle(64.45, 222.92, 0),
		fov = 0.33
	}
	return self.model
end

function ITEM:OnRegistered()
	--self:SetData("permit",(self.permit or "none"))
end

function ITEM:PopulateTooltip(tooltip)
	local data = tooltip:AddRow("data")
	data:SetBackgroundColor(Color(223,67,255))
	data:SetText("Owner: " .. self:GetData("owner_name", "UNISSUED") .. "\n" .. "CID Owner: #" .. self:GetData("cid", "NO CID ISSUED").."\nPermit: ".. self.permitCard)
	data:SizeToContents()
	local data2 = tooltip:AddRow("data")
	data2:SetBackgroundColor(Color(255, 100, 0))
	data2:SetFont("BudgetLabel")
	data2:SetText("<:: [WARNING:] ::>\nThis PERMIT contains a UU issued RFID chip.\nFailure to show this card when dealing with business related activities will result in prosecution by local CCA units.")
	data2:SizeToContents()
end

ITEM.functions.Assign = {
	name = "Assign CID",
	OnRun = function(item)
		local client = item.player

		local ent = client:GetEyeTrace().Entity
		if ent:IsPlayer() then
			item:SetData("owner_name", ent:GetName())
			item:SetData("cid", ent:GetNWString("cid", "ERR NO CID"))
		else
			client:Notify("You are not looking at a valid citizen")
		end
		return false
	end,
	OnCanRun = function(item)
		if item:GetData("owner_name") == nil and item:GetData("cid") == nil and item.player:IsCombine() then
			return true
		else
			return false
		end
	end
}