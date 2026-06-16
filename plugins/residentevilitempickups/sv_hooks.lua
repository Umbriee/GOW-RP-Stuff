
util.AddNetworkString("ixNewItemPickup")

-- Called after an item is added to an inventory.
function PLUGIN:InventoryItemAdded(oldInv, inventory, item)
	local client = inventory:GetOwner()

	if (!client) then return end

	item = ix.item.instances[item.id]

	net.Start("ixNewItemPickup")
	net.WriteString(item.name)
	net.WriteString(item.model)
	net.WriteString(item.skin or 0)
	net.WriteString(item.description)
	net.Send(client)
end
