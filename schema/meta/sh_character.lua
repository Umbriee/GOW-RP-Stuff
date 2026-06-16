
local CHAR = ix.meta.character

function CHAR:IsCOG()
	local faction = self:GetFaction()
	return faction == FACTION_MPF or faction == FACTION_OTA--return faction == FACTION_MPF or faction == FACTION_OTA
end
