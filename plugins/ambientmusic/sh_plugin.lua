
local PLUGIN = PLUGIN

PLUGIN.name = "Ambient Music"
PLUGIN.description = "Adds a system to play and configure ambient music on the client side."
PLUGIN.author = "bruck"
PLUGIN.license = [[
Copyright 2025 bruck
This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
]]

ix.util.IncludeDir(PLUGIN.folder .. "/hooks", true)
ix.util.IncludeDir(PLUGIN.folder .. "/meta", true)
ix.util.Include("sh_config.lua")

-- do NOT include the 'sound/' prefix in your file names for the track list
PLUGIN.ambientTracks = {
	"gmmp/gow1_actionstealth.ogg",
	"gmmp/gow1_adamswalk.ogg",
	"gmmp/gow1_ambient01.ogg",
	"gmmp/gow1_ambient02.ogg",
	"gmmp/gow1_ambient03.ogg",
	"gmmp/gow1_ambient06.ogg",
	"gmmp/gow1_ambient07.ogg",
	"gmmp/gow1_ambient08.ogg",
	"gmmp/gow1_gasstationexplore.ogg",
	"gmmp/gow1_gowthemelite.ogg",
	"gmmp/gow1_hoswalk.ogg",
	"gmmp/gow1_locustcreatures.ogg",
	"gmmp/gow1_locustcreep.ogg",
	"gmmp/gow1_locustcreepaltambient.ogg",
	"gmmp/gow1_locusthorror.ogg",
	"gmmp/gow1_menu.ogg",
	"gmmp/gow2_ambient01.ogg",
	"gmmp/gow2_ambient02.ogg",
	"gmmp/gow2_horrorambient.ogg",
	"gmmp/gow2_landownambient.ogg",
	"gmmp/gow2_locustambient01.ogg",
	"gmmp/gow2_outpostambient.ogg",
	"gmmp/gow2_riftworm_ambience.ogg",
	"gmmp/gow3_horrorambient.ogg",
	"gmmp/gowj_eday.ogg",
	"gmmp/gowj_sp00_mainmenup1.ogg",
	"gmmp/gowj_sp00_mainmenup2.ogg",
	"gmmp/gowj_sp00_mainmenup3.ogg",
	"gmmp/gowj_sp00_museum_lookingforconvoy_intro.ogg",
	"gmmp/gowj_sp01_ravensnest_ambient.ogg",
	"gmmp/gowj_sp01_ravensnest_ambientintro.ogg",
	"gmmp/gowj_sp02_hanover_intro.ogg",
	"gmmp/gowj_sp02_mansion_forbiddenstreets_ambient.ogg",
	"gmmp/gowj_sp02_stadium_ambient_70s.ogg",
	"gmmp/gowj_sp03_bridge_ambient.ogg",
	"gmmp/gowj_sp03_island_landing_ambient.ogg",
	"gmmp/gowj_sp03_island_radarstation.ogg",
	"gmmp/gowj_sp04_rooftops_rooftops.ogg",
	"gmmp/gowj_sp04_rooftops_street.ogg",
	"gmmp/gowj_sp05_badlands_ambient.ogg",
	"gmmp/gowj_sp05_badlands_ambientintro.ogg",
	"gmmp/gowj_sp05_courthouse_assaultupperarea.ogg",
	"gmmp/gowj_sp09_mercy_ambient.ogg",
	"gmmp/gowj_sp10_char_ambient.ogg",
	"gmmp/uw-ambient1.ogg",
	"gmmp/uw_anticipation 1.ogg",
	"gmmp/uw_anticipation 2.ogg",
	"gmmp/uw_anticipation 3.ogg",
	"gmmp/uw_cog-base-idle1.ogg",
	"gmmp/uw_cog-base-idle2.ogg",
	"gmmp/uw_asphoaudio.ogg",
	"gmmp/uw_embryaudio.ogg"
}