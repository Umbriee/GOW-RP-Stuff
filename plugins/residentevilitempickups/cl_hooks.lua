
net.Receive("ixNewItemPickup", function()
	if (LocalPlayer().ixItemInspector) then return end

	local itemFile = file.Read("helix/iteminspector.txt", "DATA")
	local itemName = net.ReadString()
	
	if (itemFile and string.find(itemFile, itemName, 1, true)) then
		return
	else
		if (!itemFile) then
			file.Write("helix/iteminspector.txt", itemName .. ",")
		else
			file.Append("helix/iteminspector.txt", itemName .. ",")
		end
	end

	local itemInspector = vgui.Create("ixItemInspector")

	local itemModel = net.ReadString()
	local itemSkin = net.ReadString()
	local itemDescription = net.ReadString()

	itemInspector:Populate(itemModel, itemSkin, itemName, itemDescription)
end)

-- Called before the player's movements are sent to the server.
function PLUGIN:CreateMove(CUserCmd)
	if (LocalPlayer().ixItemInspector) then
		CUserCmd:ClearMovement()
	end
end
