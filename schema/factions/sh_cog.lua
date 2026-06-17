FACTION.name = "Coaltion of Ordered Governments"
FACTION.description = "The Coalition of Ordered Governments, COG. Soldiers."
FACTION.color = Color(50, 100, 150)
FACTION.pay = 10
FACTION.models = {
	"models/gearsofwar/players/custom/cog/redshirt_gow1.mdl",
	"models/gearsofwar/players/custom/cog/redshirt.mdl",
	"models/gearsofwar/players/custom/cog/redshirt_gow3.mdl",

	"models/gearsofwar/players/custom/cog/anthony_carmine_gow1.mdl",
	"models/gearsofwar/players/custom/cog/anthony_carmine.mdl",

	"models/gearsofwar/players/custom/cog/benjamin_carmine.mdl",
	{"models/gearsofwar/players/custom/cog/benjamin_carmine_gow2.mdl",0,{0}},

	{ -- If you're curious, I have to do [1] just so I can keep compatability with a lot, and a lot, of things at once.
		[1]		= "models/gearsofwar/players/custom/cog/cog_template.mdl",
		-- customskin	= {0,1},
		customgroups	= {
			Body	= {
				index		= 1,
				min			= 0,
				max			= 2
			},
			Helmet	= {
				index		= 2,
				min			= 0,
				max			= 5
			},
			Torso	= {
				index		= 3,
				min			= 0,
				max			= 26,
				blacklist	= {1,21,22}
			},
			Arms	= {
				index		= 4,
				min			= 0,
				max			= 20,
				blacklist	= {1,16,17,22}
			},
			Pants	={
				index		= 5,
				min			= 0,
				max			= 26,
				blacklist	= {1,21}
			}
		}
	},
	"models/gearsofwar/players/custom/cog/cog_template_female.mdl",
	{
		[1] = "models/gearsofwar/players/custom/cog/baird_gowj.mdl",
		customskin = {0,2}
	}
}
FACTION.weapons = {
	-- "ix_stunstick"
}
FACTION.isDefault = true
FACTION.isGloballyRecognized = true

sound.Add( { -- GOWRP.COGRun
	name = "GOWRP.COGRun",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 75,
	pitch = { 98, 107 },
	sound = {
		Sound("vo/player/common_gow/cogbodyrun01.wav"),
		Sound("vo/player/common_gow/cogbodyrun02.wav"),
		Sound("vo/player/common_gow/cogbodyrun03.wav"),
		Sound("vo/player/common_gow/cogbodyrun04.wav"),
		Sound("vo/player/common_gow/cogbodyrun05.wav"),
		Sound("vo/player/common_gow/cogbodyrun06.wav"),
		Sound("vo/player/common_gow/cogbodyrun07.wav"),
		Sound("vo/player/common_gow/cogbodyrun08.wav"),
		Sound("vo/player/common_gow/cogbodyrun09.wav"),
		Sound("vo/player/common_gow/cogbodyrun10.wav"),
		Sound("vo/player/common_gow/cogbodyrun11.wav"),
		Sound("vo/player/common_gow/cogbodyrun12.wav"),
		Sound("vo/player/common_gow/cogbodyrun13.wav"),
		Sound("vo/player/common_gow/cogbodyrun14.wav")
	}
} )
sound.Add( { -- GOWRP.COGWalk
	name = "GOWRP.COGWalk",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 75,
	pitch = { 98, 107 },
	sound = {
		Sound("vo/player/common_gow/cogbodywalk01.wav"),
		Sound("vo/player/common_gow/cogbodywalk02.wav"),
		Sound("vo/player/common_gow/cogbodywalk03.wav"),
		Sound("vo/player/common_gow/cogbodywalk04.wav"),
		Sound("vo/player/common_gow/cogbodywalk05.wav"),
		Sound("vo/player/common_gow/cogbodywalk06.wav"),
		Sound("vo/player/common_gow/cogbodywalk07.wav"),
		Sound("vo/player/common_gow/cogbodywalk08.wav"),
		Sound("vo/player/common_gow/cogbodywalk09.wav"),
		Sound("vo/player/common_gow/cogbodywalk10.wav"),
		Sound("vo/player/common_gow/cogbodywalk11.wav"),
		Sound("vo/player/common_gow/cogbodywalk12.wav"),
		Sound("vo/player/common_gow/cogbodywalk13.wav")
	}
} )
sound.Add( { -- GOWRP.COGTacComOff
	name = "GOWRP.COGTacComOff",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 75,
	pitch = { 98, 107 },
	sound = Sound("gowrp/gow1/radio/TacComStop01.ogg")
} ) -- NPC_MetroPolice.Radio.On
sound.Add( { -- GOWRP.COGTacComOn
	name = "GOWRP.COGTacComOn",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 75,
	pitch = { 98, 107 },
	sound = Sound("gowrp/gow1/radio/TacComStart01.ogg")
} ) -- NPC_MetroPolice.Radio.Off

FACTION.runSounds 		= {[0] = "GOWRP.COGRun", [1] = "GOWRP.COGRun"}
FACTION.runOverride 	= false
FACTION.walkSounds		= {[0] = "GOWRP.COGWalk"}
FACTION.walkOverride	= false
FACTION.radioOff		= "GOWRP.COGTacComOff"
FACTION.radioOn			= "GOWRP.COGTacComOn"
-- FACTION.painSND			= "GOWRP.OTAPain"
-- FACTION.dieSND			= "GOWRP.OTADie"


function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("snubpistol", 1)
	inventory:Add("pistolammo", 2)
	inventory:Add("duffel",1) -- Until I can find that kit thingy.

	local number = Schema:ZeroNumber(math.random(1, 99999), 5)
	inventory:Add("cogtag",1,{
		id = number,
		name = character:GetName()
	})
	local numberleft = string.Left(number,2)
	local numberright = string.Right(number,3)
	character:SetData("id", number)
	character:SetData("callsign","COG "..numberleft.."-"..numberright)
	character:SetName("Gear-RCT "..number.." "..character:GetName())
end

FACTION_MPF = FACTION.index
