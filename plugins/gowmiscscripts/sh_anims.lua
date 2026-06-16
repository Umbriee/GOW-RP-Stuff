local PLUGIN = PLUGIN

CreateConVar( "sv_allow_alternate_run", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Whether or not to enable the alternate running animation.")
CreateClientConVar("cl_allow_alternate_run", 1, true, false, "Whether or not to enable the alternate running animation.")


function PLUGIN:PlayerFireAnimationEvent(Player,pos,ang,event,name)
	Player.SoundEvade = { "weapons/common_gow/CogBodyLunge01.ogg", "weapons/common_gow/CogBodyLunge02.ogg", "weapons/common_gow/CogBodyLunge03.ogg" }
	Player.SoundLand = { "weapons/common_gow/CogBodyRoll01.ogg", "weapons/common_gow/CogBodyRoll02.ogg", "weapons/common_gow/CogBodyRoll03.ogg" }
	
	if name == "GOWCommon.Evade_Start" then
		local sound = table.Random(Player.SoundEvade)
		Player:EmitSound(sound)
	elseif name == "GOWCommon.Evade_Land" and Player:IsOnGround() then
		local sound = table.Random(Player.SoundLand)
		Player:EmitSound(sound)
	end 
end

local function IsRetroClassWeapon( s )
	return string.find( s, "retrolancer" )
end

function PLUGIN:CalcMainActivity( Player, Velocity )
	if GetConVar("sv_allow_alternate_run"):GetBool() == 0 or GetConVar("cl_allow_alternate_run"):GetBool() == 0 then return end

	if !IsValid(Player) or Player:InVehicle() then return end

	local weapon = Player:GetActiveWeapon()
	if !IsValid(weapon) then return end

	local model     = Player:GetModel()
	local modelname = string.find(model, "gearsofwar") or string.find(model, "the_bourne_conspiracy") or string.find(model, "dead_space")
	local holdType  = weapon:GetHoldType()

	local sprinting = Player:IsOnGround() and Velocity:Length() > Player:GetRunSpeed() - 10 and Player:IsSprinting()
	if sprinting then
		if modelname == nil then
			if holdType == "smg" or holdType == "ar2" or holdType == "shotgun" or holdType == "crossbow" or holdType == "rpg" or holdType == "passive" or holdType == "physgun" then
				return ACT_HL2MP_RUN_PASSIVE, -1
			else
				return ACT_HL2MP_RUN_FAST, -1
			end
		else
			if (weapon:GetNWBool( "RETRO.ACTIVE", false ) or weapon.RetroCharging) and IsRetroClassWeapon( weapon:GetClass() ) then
				return ACT_SPRINT, -1
			end
			if holdType == "smg" or holdType == "ar2" or holdType == "shotgun" or holdType == "crossbow" or holdType == "rpg" or holdType == "passive" or holdType == "physgun" then
				return ACT_HL2MP_RUN_FAST, -1
			elseif holdType == "melee2" or holdType == "melee" or holdType == "knife" then
				return ACT_HL2MP_RUN_PROTECTED, -1
			else
				return ACT_HL2MP_RUN_CHARGING, -1
			end
		end
	end
end