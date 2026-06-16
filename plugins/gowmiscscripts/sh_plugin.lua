local PLUGIN = PLUGIN

PLUGIN.name = "[GOW] - Misc Scripts"
PLUGIN.description = "Mmm.. Gears."
PLUGIN.author = "Dopey & Umbree and other such notable mentions."
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

--==[[ Liscense less applies as this is a helix port from the workshop addon: 'https://steamcommunity.com/sharedfiles/filedetails/?id=2973281005' in which having that breaks a couple things due to a few hook overwriting that Helix uses.]]==--

ix.util.Include("sh_anims.lua",		"shared")
ix.util.Include("sh_gowgibs.lua",	"shared")