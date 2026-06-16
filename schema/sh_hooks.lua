
function Schema:CanPlayerUseBusiness(client, uniqueID)
	if (client:Team() == FACTION_CITIZEN) then
		local itemTable = ix.item.list[uniqueID]

		if (itemTable) then
			if (itemTable.permit) then
				local character = client:GetCharacter()
				local inventory = character:GetInventory()

				if (!inventory:HasItem("permit_"..itemTable.permit)) then
					return false
				end
			elseif (itemTable.base ~= "base_permit") then
				return false
			end
		end
	end
end

-- called when the client wants to view the combine data for the given target
function Schema:CanPlayerViewData(client, target)
	return client:IsCOG() and (!target:IsCOG())
end

-- called when the client wants to edit the combine data for the given target
function Schema:CanPlayerEditData(client, target)
	return client:IsCOG() and (!target:IsCOG())
end

function Schema:CanPlayerViewObjectives(client)
	return client:IsCOG()
end

function Schema:CanPlayerEditObjectives(client)
	if (!client:IsCOG() or !client:GetCharacter()) then
		return false
	end

	local bCanEdit = false
	local name = client:GetCharacter():GetName()

	for k, v in ipairs({"OfC", "EpU", "DvL", "SeC"}) do
		if (self:IsRank(name, v)) then
			bCanEdit = true
			break
		end
	end

	return bCanEdit
end

function Schema:CanDrive()
	return false
end

do
	local KEY_BLACKLIST = bit.bor( IN_ATTACK, IN_ATTACK2 )
	function GM:StartCommand(client, command)
		if not client:InVehicle() then
			if (!client:CanShootWeapon()) then
				command:RemoveKey(KEY_BLACKLIST)
			end
		end
	end
end