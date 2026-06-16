local PLUGIN = PLUGIN

PLUGIN.name = "Huds and huds and cooler huds v2"
PLUGIN.description = "Let me colour your world."
PLUGIN.author = "Umbree"
PLUGIN.schema = "Any"
PLUGIN.license = [[
|													--==| Copyright 2026 Umbree Jones |==--																			|
|	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),				|
|		to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,			|
|			and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:				|
|																																									|
|		--==|| "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software." ||==--				|
|																																									|
|	    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 		|
|  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 	|
|    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.		|
]]

PLUGIN.config = {
	drawTime = 3
}
PLUGIN.huddrawdata = {}

ix.lang.AddTable("english", {
	optHudmargin	= "Hud Margin",
	optHudquality	= "Hud Curve Quality",
	optHudtime		= "Hud Draw Time",
	optHudscale		= "Hud Scale",

	optdHudmargin	= "How much the screen curves on itself. 0 = off",
	optdHudquality	= "How detailed the curved screen gets. 0 = off with increasing quality to a max of 5. Lower qualities are easier on performance but can induce warping!",
	optdHudtime		= "The hud draws everything to a texture and thus I can get away with not updating it every frame. Saving performance. How often do you want it to update in microseconds?",
	optdHudscale	= "Should the hud be scaled up or down, depending on your preference.",

	optHuddebug		= "Debug Hud",
	optdHuddebug	= "This setting is *extremely* performance heavy. It is used to debug the exact bounds of the curved screen and how they look. It is draw in hud space for every frame."
})

if CLIENT then
	ix.option.Add("hudquality", ix.type.number, 2, {
		category = PLUGIN.name, min = 0, max = 5
	})
	ix.option.Add("hudmargin", ix.type.number, 0.1, {
		category = PLUGIN.name, min = 0, max = 1, decimals = 1
	})
	ix.option.Add("hudtime", ix.type.number, 20, {
		category = PLUGIN.name, min = 0, max = 1000
	})
	ix.option.Add("hudscale", ix.type.number, 1.0, {
		category = PLUGIN.name, min = 0.1, max = 2, decimals = 1
	})

	ix.option.Add("huddebug", ix.type.bool, false, {
		category = PLUGIN.name
	})
end

ix.util.Include("sv_plugin.lua",	"server")
ix.util.Include("cl_util.lua",		"client")
ix.util.Include("cl_plugin.lua",	"client")

ix.util.IncludeDir(PLUGIN.folder .. "/huds", true)