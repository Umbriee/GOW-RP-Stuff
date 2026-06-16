local playerMeta = FindMetaTable("Player")

function playerMeta:IsCOG()
	local faction = self:Team()
	if not faction then return false end

	local combineFactions = {
		[FACTION_MPF] = true,
		[FACTION_OTA] = true
	}

	return combineFactions[faction] or false
end
function playerMeta:IsUIR()
	local faction = self:Team()
	return faction == FACTION_UIR
end

function playerMeta:IsStranded()
	local faction = self:Team()
	return faction == FACTION_CITIZEN
end

function playerMeta:IsDispatch()
	return false
end

function playerMeta:GetRoleData(key, fallback)
	if not self:GetCharacter() then return fallback or "NIL" end

	local factionTable = ix.faction.Get(self:Team())
	local classTable = ix.class.Get(self:GetCharacter():GetClass())

	local value = (classTable and classTable[key]) or (factionTable and factionTable[key]) or fallback or "NIL"
	return value
end