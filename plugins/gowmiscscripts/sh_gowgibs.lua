local PLUGIN = PLUGIN

CreateConVar("GOWGibs_Enable", 1, bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("GOWGibs_DMG_Threshold", 50, bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE))

GibsTbl = {
	["models/dead_space/players/ds1_lvl1_suit.mdl"] = "models/dead_space/players/ds1_lvl1_gib.mdl",
	["models/dead_space/players/ds1_lvl2_suit.mdl"] = "models/dead_space/players/ds1_lvl2_gib.mdl",
	["models/dead_space/players/ds1_lvl3_suit.mdl"] = "models/dead_space/players/ds1_lvl3_gib.mdl",
	["models/dead_space/players/ds1_lvl4_suit.mdl"] = "models/dead_space/players/ds1_lvl4_gib.mdl",
	["models/dead_space/players/ds1_lvl5_suit.mdl"] = "models/dead_space/players/ds1_lvl5_gib.mdl",
	["models/dead_space/players/ds1_lvl6_suit.mdl"] = "models/dead_space/players/ds1_lvl6_gib.mdl",
	["models/gearsofwar/players/custom/cog/adam_fenix.mdl"] = "models/gearsofwar/players/gore/cog/adam_fenix.mdl",
	["models/gearsofwar/players/custom/cog/alex_brand.mdl"] = "models/gearsofwar/players/gore/cog/alex_brand.mdl",
	["models/gearsofwar/players/custom/cog/anthony_carmine.mdl"] = "models/gearsofwar/players/gore/cog/kim_gow3.mdl",
	["models/gearsofwar/players/custom/cog/anthony_carmine_gow1.mdl"] = "models/gearsofwar/players/gore/cog/kim_gow3.mdl",
	["models/gearsofwar/players/custom/cog/benjamin_carmine.mdl"] = "models/gearsofwar/players/gore/cog/kim_gow3.mdl",
	["models/gearsofwar/players/custom/cog/benjamin_carmine_gow2.mdl"] = "models/gearsofwar/players/gore/cog/kim_gow3.mdl",
	["models/gearsofwar/players/custom/cog/anya.mdl"] = "models/gearsofwar/players/gore/cog/anya.mdl",
	["models/gearsofwar/players/custom/cog/anya_civilian.mdl"] = "models/gearsofwar/players/gore/cog/anya_civilian.mdl",
	["models/gearsofwar/players/custom/cog/baird_gow1.mdl"] = "models/gearsofwar/players/gore/cog/baird_gow1.mdl",
	["models/gearsofwar/players/custom/cog/baird_gow2.mdl"] = "models/gearsofwar/players/gore/cog/baird_gow1.mdl",
	["models/gearsofwar/players/custom/cog/baird_gowj.mdl"] = "models/gearsofwar/players/gore/cog/baird_gowj.mdl",
	["models/gearsofwar/players/custom/cog/baird_gow3.mdl"] = "models/gearsofwar/players/gore/cog/baird_gow3.mdl",
	["models/gearsofwar/players/custom/cog/baird_worker.mdl"] = "models/gearsofwar/players/gore/cog/baird_worker.mdl",
	["models/gearsofwar/players/custom/cog/barrick.mdl"] = "models/gearsofwar/players/gore/cog/barrick.mdl",
	["models/gearsofwar/players/custom/cog/bernie.mdl"] = "models/gearsofwar/players/gore/cog/bernie.mdl",
	["models/gearsofwar/players/custom/cog/clayton_carmine.mdl"] = "models/gearsofwar/players/gore/cog/clayton_carmine.mdl",
	["models/gearsofwar/players/custom/cog/clayton_carmine_classic.mdl"] = "models/gearsofwar/players/gore/cog/clayton_carmine_classic.mdl",
	["models/gearsofwar/players/custom/cog/cole_aftermath.mdl"] = "models/gearsofwar/players/gore/cog/cole_aftermath.mdl",
	["models/gearsofwar/players/custom/cog/cole_classic.mdl"] = "models/gearsofwar/players/gore/cog/cole_classic.mdl",
	["models/gearsofwar/players/custom/cog/cole_gow1.mdl"] = "models/gearsofwar/players/gore/cog/cole_classic.mdl",
	["models/gearsofwar/players/custom/cog/cole_judgement.mdl"] = "models/gearsofwar/players/gore/cog/cole_judgement.mdl",
	["models/gearsofwar/players/custom/cog/cole_superstar.mdl"] = "models/gearsofwar/players/gore/cog/cole_superstar.mdl",
	["models/gearsofwar/players/custom/cog/cole_thrashball.mdl"] = "models/gearsofwar/players/gore/cog/cole_thrashball.mdl",
	["models/gearsofwar/players/custom/cog/greyson.mdl"] = "models/gearsofwar/players/gore/cog/greyson.mdl",
	["models/gearsofwar/players/custom/cog/dizzy.mdl"] = "models/gearsofwar/players/gore/cog/dizzy.mdl",
	["models/gearsofwar/players/custom/cog/dizzy_gow2.mdl"] = "models/gearsofwar/players/gore/cog/dizzy.mdl",
	["models/gearsofwar/players/custom/cog/dom_commando.mdl"] = "models/gearsofwar/players/gore/cog/dom_commando.mdl",
	["models/gearsofwar/players/custom/cog/dom_gow1.mdl"] = "models/gearsofwar/players/gore/cog/dom_gow1.mdl",
	["models/gearsofwar/players/custom/cog/dom_gow2.mdl"] = "models/gearsofwar/players/gore/cog/dom_gow1.mdl",
	["models/gearsofwar/players/custom/cog/dom_gow3.mdl"] = "models/gearsofwar/players/gore/cog/dom_gow3.mdl",
	["models/gearsofwar/players/custom/cog/dom_young.mdl"] = "models/gearsofwar/players/gore/cog/dom_young.mdl",
	["models/gearsofwar/players/custom/cog/female_onyx_guard.mdl"] = "models/gearsofwar/players/gore/cog/female_onyx_guard.mdl",
	["models/gearsofwar/players/custom/cog/hoffman_gow1.mdl"] = "models/gearsofwar/players/gore/cog/hoffman_gow1.mdl",
	["models/gearsofwar/players/custom/cog/hoffman_aftermath.mdl"] = "models/gearsofwar/players/gore/cog/hoffman_aftermath.mdl",
	["models/gearsofwar/players/custom/cog/jace.mdl"] = "models/gearsofwar/players/gore/cog/jace.mdl",
	["models/gearsofwar/players/custom/cog/kim_gow1.mdl"] = "models/gearsofwar/players/gore/cog/kim_gow3.mdl",
	["models/gearsofwar/players/custom/cog/kim_gow3.mdl"] = "models/gearsofwar/players/gore/cog/kim_gow3.mdl",
	["models/gearsofwar/players/custom/cog/loomis.mdl"] = "models/gearsofwar/players/gore/cog/loomis.mdl",
	["models/gearsofwar/players/custom/cog/marcus_gow1.mdl"] = "models/gearsofwar/players/gore/cog/marcus_gow1.mdl",
	["models/gearsofwar/players/custom/cog/marcus_gow2.mdl"] = "models/gearsofwar/players/gore/cog/marcus_gow1.mdl",
	["models/gearsofwar/players/custom/cog/marcus_gow3.mdl"] = "models/gearsofwar/players/gore/cog/marcus_gow3.mdl",
	["models/gearsofwar/players/custom/cog/marcus_young.mdl"] = "models/gearsofwar/players/gore/cog/marcus_young.mdl",
	["models/gearsofwar/players/custom/cog/marcus_noarmor.mdl"] = "models/gearsofwar/players/gore/cog/marcus_noarmor.mdl",
	["models/gearsofwar/players/custom/cog/tai_tribal.mdl"] = "models/gearsofwar/players/gore/cog/tai_tribal.mdl",
	["models/gearsofwar/players/custom/cog/trishka_novak.mdl"] = "models/gearsofwar/players/gore/cog/trishka_novak.mdl",
	["models/gearsofwar/players/custom/cog/onyx_guard.mdl"] = "models/gearsofwar/players/gore/cog/onyx_guard.mdl",
	["models/gearsofwar/players/custom/cog/paduk_aftermath.mdl"] = "models/gearsofwar/players/gore/cog/paduk_aftermath.mdl",
	["models/gearsofwar/players/custom/cog/paduk_judgement.mdl"] = "models/gearsofwar/players/gore/cog/paduk_judgement.mdl",
	["models/gearsofwar/players/custom/uir/uir_trooper_ue.mdl"] = "models/gearsofwar/players/gore/uir/NPC_UIR_Gore01.mdl",
	["models/gearsofwar/players/custom/uir/uir_female_trooper_ue.mdl"] = "models/gearsofwar/players/gore/uir/NPC_UIR_Gore01.mdl",
	["models/gearsofwar/players/custom/cog/prescott.mdl"] = "models/gearsofwar/players/gore/cog/prescott.mdl",
	["models/gearsofwar/players/custom/cog/redshirt.mdl"] = "models/gearsofwar/players/gore/cog/kim_gow3.mdl",
	["models/gearsofwar/players/custom/cog/redshirt_gow1.mdl"] = "models/gearsofwar/players/gore/cog/kim_gow3.mdl",
	["models/gearsofwar/players/custom/cog/redshirt_gow3.mdl"] = "models/gearsofwar/players/gore/cog/redshirt_gow3.mdl",
	["models/gearsofwar/players/custom/cog/sam.mdl"] = "models/gearsofwar/players/gore/cog/sam.mdl",
	["models/gearsofwar/players/custom/cog/adam_fenix.mdl"] = "models/gearsofwar/players/gore/cog/adam_fenix.mdl",
	["models/gearsofwar/players/custom/cog/adam_fenix.mdl"] = "models/gearsofwar/players/gore/cog/adam_fenix.mdl",
	["models/gearsofwar/players/custom/cog/sofia.mdl"] = "models/gearsofwar/players/gore/cog/sofia.mdl",
	["models/gearsofwar/players/custom/cog/tai_judgement.mdl"] = "models/gearsofwar/players/gore/cog/tai_judgement.mdl",
	["models/gearsofwar/players/custom/cog/valera.mdl"] = "models/gearsofwar/players/gore/cog/valera.mdl",
	["models/gearsofwar/players/custom/locust/beastrider.mdl"] = "models/gearsofwar/players/gore/locust/drone.mdl",
	["models/gearsofwar/players/custom/locust/bolter.mdl"] = "models/gearsofwar/players/gore/locust/drone.mdl",
	["models/gearsofwar/players/custom/locust/cyclops.mdl"] = "models/gearsofwar/players/gore/locust/drone.mdl",
	["models/gearsofwar/players/custom/locust/drone.mdl"] = "models/gearsofwar/players/gore/locust/drone.mdl",
	["models/gearsofwar/players/custom/locust/drone_gow1.mdl"] = "models/gearsofwar/players/gore/locust/drone.mdl",
	["models/gearsofwar/players/custom/locust/flame_drone.mdl"] = "models/gearsofwar/players/gore/locust/drone.mdl",
	["models/gearsofwar/players/custom/locust/grappler.mdl"] = "models/gearsofwar/players/gore/locust/drone.mdl",
	["models/gearsofwar/players/custom/locust/miner.mdl"] = "models/gearsofwar/players/gore/locust/drone.mdl",
	["models/gearsofwar/players/custom/locust/sniper.mdl"] = "models/gearsofwar/players/gore/locust/drone.mdl",
	["models/gearsofwar/players/custom/locust/spotter.mdl"] = "models/gearsofwar/players/gore/locust/drone.mdl",
	["models/gearsofwar/players/custom/locust/flamer.mdl"] = "models/gearsofwar/players/gore/locust/grenadier_elite.mdl",
	["models/gearsofwar/players/custom/locust/grenadier_elite.mdl"] = "models/gearsofwar/players/gore/locust/grenadier_elite.mdl",
	["models/gearsofwar/players/custom/locust/grenadier.mdl"] = "models/gearsofwar/players/gore/locust/grenadier.mdl",
	["models/gearsofwar/players/custom/locust/kantus.mdl"] = "models/gearsofwar/players/gore/locust/kantus.mdl",
	["models/gearsofwar/players/custom/locust/kantus_gow2.mdl"] = "models/gearsofwar/players/gore/locust/kantus.mdl",
	["models/gearsofwar/players/custom/locust/karn.mdl"] = "models/gearsofwar/players/gore/locust/karn.mdl",
	["models/gearsofwar/players/custom/locust/palace_guard.mdl"] = "models/gearsofwar/players/gore/locust/palace_guard.mdl",
	["models/gearsofwar/players/custom/locust/grenadier.mdl"] = "models/gearsofwar/players/gore/locust/grenadier.mdl",
	["models/gearsofwar/players/custom/locust/raam.mdl"] = "models/gearsofwar/players/gore/locust/raam.mdl",
	["models/gearsofwar/players/custom/locust/rager.mdl"] = "models/gearsofwar/players/gore/locust/rager.mdl",
	["models/gearsofwar/players/custom/locust/savage_creeper.mdl"] = "models/gearsofwar/players/gore/locust/savage_creeper.mdl",
	["models/gearsofwar/players/custom/locust/savage_drone.mdl"] = "models/gearsofwar/players/gore/locust/savage_drone.mdl",
	["models/gearsofwar/players/custom/locust/savage_grenadier.mdl"] = "models/gearsofwar/players/gore/locust/savage_grenadier.mdl",
	["models/gearsofwar/players/custom/locust/savage_grenadier_elite.mdl"] = "models/gearsofwar/players/gore/locust/savage_grenadier_elite.mdl",
	["models/gearsofwar/players/custom/locust/savage_kantus.mdl"] = "models/gearsofwar/players/gore/locust/savage_kantus.mdl",
	["models/gearsofwar/players/custom/locust/savage_marauder.mdl"] = "models/gearsofwar/players/gore/locust/savage_marauder.mdl",
	["models/gearsofwar/players/custom/locust/savage_theron.mdl"] = "models/gearsofwar/players/gore/locust/savage_theron.mdl",
	["models/gearsofwar/players/custom/locust/skorge.mdl"] = "models/gearsofwar/players/gore/locust/kantus.mdl",
	["models/gearsofwar/players/custom/locust/grenadier.mdl"] = "models/gearsofwar/players/gore/locust/grenadier.mdl",
	["models/gearsofwar/players/custom/locust/theron_guard.mdl"] = "models/gearsofwar/players/gore/locust/theron_guard.mdl",
	["models/gearsofwar/players/custom/locust/theron_guard_elite.mdl"] = "models/gearsofwar/players/gore/locust/theron_guard_elite.mdl",
	["models/gearsofwar/players/custom/locust/boomer.mdl"] = "models/gearsofwar/players/gore/locust/boomer.mdl",
	["models/gearsofwar/players/custom/locust/butcher.mdl"] = "models/gearsofwar/players/gore/locust/butcher.mdl",
	["models/gearsofwar/players/custom/locust/savage_boomer.mdl"] = "models/gearsofwar/players/gore/locust/savage_boomer.mdl",
	["models/gearsofwar/players/custom/locust/myrrah.mdl"] = "models/gearsofwar/players/gore/locust/myrrah.mdl",
	["models/gearsofwar/players/custom/locust/wretch.mdl"] = "models/gearsofwar/players/gore/locust/wretch.mdl",
	["models/gearsofwar/players/custom/stranded/female_npc_02_freckles.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_chunks.mdl",
	["models/gearsofwar/players/custom/stranded/female_npc_05_redpants.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_chunks.mdl",
	["models/gearsofwar/players/custom/stranded/female_npc_06_hoodie.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_chunks.mdl",
	["models/gearsofwar/players/custom/stranded/hanover_female_npc_03.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_chunks.mdl",
	["models/gearsofwar/players/custom/stranded/npc_hanover_lady_cine.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_chunks.mdl",
	["models/gearsofwar/players/custom/stranded/hanover_male_npc_02.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_chunks.mdl",
	["models/gearsofwar/players/custom/stranded/hanover_male_npc_04.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_chunks.mdl",
	["models/gearsofwar/players/custom/stranded/male_fort_npc_01.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_1.mdl",
	["models/gearsofwar/players/custom/stranded/male_npc_01_trog.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_1.mdl",
	["models/gearsofwar/players/custom/stranded/male_npc_02_tums.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_1.mdl",
	["models/gearsofwar/players/custom/stranded/male_npc_03_harry.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_1.mdl",
	["models/gearsofwar/players/custom/stranded/male_npc_04_beardsly.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_1.mdl",
	["models/gearsofwar/players/custom/stranded/male_npc_05_mechanic.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_1.mdl",
	["models/gearsofwar/players/custom/stranded/mercy_npc_sickguycompanion.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_1.mdl",
	["models/gearsofwar/players/custom/cog/cog_template.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_1.mdl",
	["models/gearsofwar/players/custom/cog/cog_template2.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_1.mdl",
	["models/gearsofwar/players/custom/cog/cog_template3.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_1.mdl",
	["models/gearsofwar/players/custom/cog/unreal_warfare_gear.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_chunks.mdl",
	["models/gearsofwar/players/custom/cog/cog_template_female.mdl"] = "models/gearsofwar/players/gore/stranded/npc_gore_chunks.mdl",
	["models/gearsofwar/players/custom/lambent/drudge.mdl"] = "models/gearsofwar/players/gore/lambent/drudge.mdl"
}

GibDamageTypes = {
	DMG_CRUSH,
	DMG_SLASH,
	DMG_VEHICLE,
	DMG_BLAST,
	DMG_CLUB,
	DMG_SONIC,
	DMG_ENERGYBEAM,
	DMG_ALWAYSGIB,
	DMG_PLASMA,
	DMG_LASER,
	DMG_AIRBOAT
}

function PLUGIN:DoPlayerDeath( victim, attacker, dmginfo )
	if GetConVar("GOWGibs_Enable"):GetBool() then
		if (dmginfo:GetDamage() >= GetConVar("GOWGibs_DMG_Threshold"):GetInt() and dmginfo:GetDamageType(GibDamageTypes[dmg])) and not dmginfo:IsDamageType(DMG_NEVERGIB) then 
			local ent = ents.Create("prop_dynamic")
			ent:SetModel("models/player.mdl")
			ent:SetPos(victim:GetPos()+Vector(0,0,20))
			ent:Spawn()
			ent:Fire("kill","",16.5)
			
			timer.Simple(0.1, function()
				if !IsValid(ent) then return false end
				ent:SetModelScale(0.01, 0)
				if victim:GetRagdollEntity():IsValid() then
					victim:GetRagdollEntity():Remove()
				end
			end)
			-- print("Gibbed")
			ent:SetColor(Color(0, 0, 0, 0)) 
			ent:SetRenderMode(RENDERMODE_TRANSALPHA)
			ent:PhysicsInit(SOLID_NONE)
			ent:SetMoveType(MOVETYPE_VPHYSICS)
			ent:SetSolid(SOLID_NONE)
			ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			ent:DrawShadow(false)
			if SERVER then
			ParticleEffect( "astw2_gow_gib_explosion_med", victim:WorldSpaceCenter(), victim:GetAngles() )
			end 
			if CLIENT then
			ParticleEffect( "astw2_gow_gib_explosion_med", victim:WorldSpaceCenter(), victim:GetAngles() )
			end
			-- util.Decal( "astw2_gow_splatter_generic4", victim:GetPos(), victim:GetPos() - Vector(0, 0, 32), victim )
			util.Decal( "Blood", victim:GetPos(), victim:GetPos() - Vector(0, 0, 32), victim )
			sound.Play("weapons/common_gow/gibbodyexplode0"..math.random(1,5)..".ogg",ent:GetPos()+Vector(0,0,20),math.random(75,80))
			sound.Play("weapons/common_gow/gibbodyexplode0"..math.random(1,5)..".ogg",ent:GetPos()+Vector(0,0,20),math.random(75,80))
			sound.Play("weapons/common_gow/gibbodyexplode0"..math.random(1,5)..".ogg",ent:GetPos()+Vector(0,0,20),math.random(75,80))
			
		if GibsTbl[victim:GetModel()] then
			if victim:IsOnGround() then
			ParticleEffect( "astw2_gow_blood_pool", victim:GetPos(), victim:GetAngles() )
			end
			local angle = ((victim:GetPos()-dmginfo:GetDamagePosition())):Angle()
			local dir = angle:Forward():GetNormalized()
			local mdl = GibsTbl[victim:GetModel()]
			local gib = ents.Create("prop_ragdoll")
			gib:SetModel(mdl)
			gib:SetMaterial("watermelon")
			gib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			gib:SetPos(victim:GetPos())
			gib:SetAngles(victim:GetAngles())
			gib:Spawn()
			for i=1 ,gib:GetBoneCount() do -- We will position the bones and the limit will be the number bones we have
					local bone = gib:GetPhysicsObjectNum( i ) -- first we give the bone a proper name (since the ragdoll has a lot of those)
					if IsValid( bone ) then -- If valid / found bone
						local boneposition, boneangle = gib:GetBonePosition( gib:TranslatePhysBoneToBone( i ) ) -- We give our bone's position and angle a name
						bone:SetPos( boneposition ) -- we set position
						bone:SetAngles( boneangle ) -- we set angles
						bone:EnableMotion( true )
						bone:SetMaterial("watermelon")
						-- bone:ApplyForceCenter( (gib:GetUp()*2400)+dir*math.random(128,1024) )
						bone:ApplyForceCenter( (gib:GetUp()*dmginfo:GetDamageForce()/2)-dir*dmginfo:GetDamageForce()/2 )
					end
			end
			if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
				timer.Simple( 30, function()
					if IsValid(gib) then
						gib:Remove()
					end
				end)
			end
			
			else
			if victim:IsOnGround() then
			ParticleEffect( "astw2_gow_blood_pool", victim:GetPos(), victim:GetAngles() )
			end
			local angle = ((victim:GetPos()-dmginfo:GetDamagePosition())):Angle()
			local dir = angle:Forward():GetNormalized()
			local mdl = "models/gearsofwar/players/gore/stranded/npc_gore_chunks.mdl" 
			local gib = ents.Create("prop_ragdoll")
			gib:SetModel(mdl)
			gib:SetMaterial("watermelon")
			gib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			gib:SetPos(victim:GetPos())
			gib:SetAngles(victim:GetAngles())
			gib:Spawn()
			for i=1 ,gib:GetBoneCount() do -- We will position the bones and the limit will be the number bones we have
					local bone = gib:GetPhysicsObjectNum( i ) -- first we give the bone a proper name (since the ragdoll has a lot of those)
					if IsValid( bone ) then -- If valid / found bone
						local boneposition, boneangle = gib:GetBonePosition( gib:TranslatePhysBoneToBone( i ) ) -- We give our bone's position and angle a name
						bone:SetPos( boneposition ) -- we set position
						bone:SetAngles( boneangle ) -- we set angles
						bone:EnableMotion( true )
						bone:SetMaterial("watermelon")
						bone:ApplyForceCenter( (gib:GetUp()*2400)+dir*math.random(128,1024) )
					end
			end
			if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
				timer.Simple( 30, function()
					if IsValid(gib) then
						gib:Remove()
					end
				end)
			end
			
		end
			--[[local ed = EffectData()
			ed:SetOrigin( ent:GetPos()+Vector(math.random(-8,8),math.random(-8,8),1))
			ed:SetEntity( ent )
			ed:SetNormal((dmginfo:GetDamagePosition() - ent:GetPos()):GetNormal()*-1)
			if dmginfo:IsDamageType(DMG_BLAST) then
				ed:SetScale( math.Clamp(dmginfo:GetDamage()*10,1,200000) )
			else
				ed:SetScale( math.Clamp(dmginfo:GetDamage()*math.Rand(1,1.5),1,200000) )
			end
			util.Effect( "GOWgibs", ed, true, true )
			util.Effect( "GOWgibs", ed, true, true )
			util.Effect( "GOWgibs", ed, true, true )
			util.Effect( "GOWgibs", ed, true, true )
			
			local ed1 = EffectData()
			ed1:SetOrigin( ent:GetPos()+Vector(math.random(-8,8),math.random(-8,8),1))
			ed1:SetEntity( ent )
			ed1:SetNormal((dmginfo:GetDamagePosition() - ent:GetPos()):GetNormal()*-1)
			if dmginfo:IsDamageType(DMG_BLAST) then
				ed1:SetScale( math.Clamp(dmginfo:GetDamage()*10,1,200000) )
			else
				ed1:SetScale( math.Clamp(dmginfo:GetDamage()*math.Rand(1,1.5),1,200000) )
			end
			util.Effect( "GOWgibs2", ed1, true, true )
			util.Effect( "GOWgibs2", ed1, true, true )
			util.Effect( "GOWgib_head", ed1, true, true )
			util.Effect( "GOWgib_heart", ed1, true, true )
			util.Effect( "GOWgib_lung", ed1, true, true )
			util.Effect( "GOWgib_lung", ed1, true, true )
			util.Effect( "GOWgib_legbone", ed1, true, true )
			util.Effect( "GOWgib_legbone", ed1, true, true )
			util.Effect( "GOWgib_gut", ed1, true, true )
			
			local ed2 = EffectData()
			ed2:SetOrigin( ent:GetPos()+Vector(math.random(-8,8),math.random(-8,8),1))
			ed2:SetEntity( ent )
			ed2:SetNormal((dmginfo:GetDamagePosition() - ent:GetPos()):GetNormal()*-1)
			if dmginfo:IsDamageType(DMG_BLAST) then
				ed2:SetScale( math.Clamp(dmginfo:GetDamage()*10,1,200000) )
			else
				ed2:SetScale( math.Clamp(dmginfo:GetDamage()*math.Rand(1,1.5),1,200000) )
			end
			util.Effect( "GOWgibs3", ed2, true, true )
			util.Effect( "GOWgibs3", ed2, true, true )
			util.Effect( "GOWgibs3", ed2, true, true )
			util.Effect( "GOWgibs3", ed2, true, true )
			--]]
		end
	end
end

function PLUGIN:EntityTakeDamage( victim, dmginfo )
	if GetConVar("GOWGibs_Enable"):GetBool() then
		--[[if victim:IsNPC() then
			if CLIENT then
				ParticleEffect( "astw2_gow_gib_explosion_med", victim:WorldSpaceCenter(), victim:GetAngles() )
				end
				util.Decal( "Blood", victim:GetPos(), victim:GetPos() - Vector(0, 0, 32), victim )
				util.Decal( "Blood", victim:GetPos(), victim:GetPos() - Vector(0, 0, 32), victim )
				sound.Play("weapons/common_gow/gibbodyexplode0"..math.random(1,5)..".ogg",ent:GetPos()+Vector(0,0,20),math.random(75,80))
				sound.Play("weapons/common_gow/gibbodyexplode0"..math.random(1,5)..".ogg",ent:GetPos()+Vector(0,0,20),math.random(75,80))
				sound.Play("weapons/common_gow/gibbodyexplode0"..math.random(1,5)..".ogg",ent:GetPos()+Vector(0,0,20),math.random(75,80))
				
			if GibsTbl[victim:GetModel()] then
			
				local angle = ((victim:GetPos()-dmginfo:GetDamagePosition())):Angle()
				local dir = angle:Forward():GetNormalized()
				local mdl = GibsTbl[victim:GetModel()]
				local gib = ents.Create("prop_ragdoll")
				gib:SetModel(mdl)
				gib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				gib:SetPos(victim:GetPos())
				gib:SetAngles(victim:GetAngles())
				gib:Spawn()
				for i=1 ,gib:GetBoneCount() do -- We will position the bones and the limit will be the number bones we have
						local bone = gib:GetPhysicsObjectNum( i ) -- first we give the bone a proper name (since the ragdoll has a lot of those)
						if IsValid( bone ) then -- If valid / found bone
							local boneposition, boneangle = gib:GetBonePosition( gib:TranslatePhysBoneToBone( i ) ) -- We give our bone's position and angle a name
							bone:SetPos( boneposition ) -- we set position
							bone:SetAngles( boneangle ) -- we set angles
							bone:EnableMotion( true )
							bone:ApplyForceCenter( (gib:GetUp()*2400)-dir*math.random(256,512) )
						end
				end
				if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
					timer.Simple( 15, function()
						if IsValid(gib) then
							gib:Remove()
						end
					end)
				end
			end
		end--]]
	end
end