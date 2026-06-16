local PLUGIN = PLUGIN

PLUGIN.name = "Live TFA Vox Updater"
PLUGIN.description = "Let me voice your world."
PLUGIN.author = "Umbree"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2025 Umbree Jones

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]
--==[[ Yadda yadda, peepee poopoo, liscensce scmhiscense. I don't care if you tweak this or do any bit of editing as long as you just leave my name *somewhere* around here decently visible. ]]==--
PLUGIN.voxtable = {}

do
	local COMMAND = {}
	COMMAND.arguments = {ix.type.string, ix.type.string}
	COMMAND.argumentNames = {"New model path to set", "Old model path to copy"}
	COMMAND.superAdminOnly = true
	COMMAND.description = "Edits TFA VOX list to copy from another model"
	function COMMAND:OnRun(client, newStr, oldStr)
		local retn = PLUGIN:VoxReqList(_, client, 1, newStr, oldStr)
		if retn then return retn end
	end
	ix.command.Add("SetModelVox", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = {ix.type.string}
	COMMAND.argumentNames = {"Model to reset"}
	COMMAND.superAdminOnly = true
	COMMAND.description = "Remove custom from the TFA VOX list."
	function COMMAND:OnRun(client, newStr)
		local retn = PLUGIN:VoxReqList(_, client, 2, {newStr})
		if retn then return retn end
	end
	ix.command.Add("DelModelVox", COMMAND)
end

PLUGIN.debug = false
ix.util.Include("sv_hooks.lua",		"server")
ix.util.Include("sv_plugin.lua",	"server")