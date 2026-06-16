local PLUGIN = PLUGIN
local ix = ix or {}
PLUGIN.name = "UmbCO TTS"
PLUGIN.description = "Let me shittly voice your world."
PLUGIN.author = "Umbree"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2025: Umbree Jones

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]
ix.ttsvoice = {}
ix.ttsvoice.url = "http://tts.cyzon.us/tts?text=" -- Try to also keep requests to this server on the down low. They are a third party I haven't talked to and I just want to keep this plugin because its funny.
ix.ttsvoice.wait = 5
ix.ttsvoice.range = 500 -- Becareful. This number is multiplied by itself due to it being cheaper to run. Try to keep it decently low.

ix.ttsvoice.begin = false

ix.util.Include("sv_plugin.lua","server")
ix.util.Include("cl_plugin.lua","client")

ix.flag.Add("V", "Gives access to the TTS command.")
-- CharacterObj:HasFlags("V")

function PLUGIN:URLEncode(str)
	--[[ 
		Hopefully encodes every unsafe URL character according to RFC 3986 or something. I'm not a website or audio engineer, man.
		All I know it takes the space character and makes it into %20.
	--]] 
	if str == nil then return "error1" end
	str = tostring(str)
	str = string.gsub(str, "\n", "\r\n")
	str = string.gsub(str, "([^%w%-_%.%~])", function(c)
		return string.format("%%%02X", string.byte(c))
	end)
	return str
end
function PLUGIN:TTSUse(ent) -- I know I can compress these. But I'm lazy. --
	if ent then
		if ent:IsValid() then
			if ent:IsPlayer() then
				if ent:GetCharacter() then
					local char = ent:GetCharacter()
					if char:HasFlags("V") then
						return true
					else
						return false
					end
				end
			end
		end
	end
	return false
end

ix.command.Add("tts", {
	description = "State something in your beautiful voice.",
	arguments = {
		ix.type.text,
	},
	OnCanRun = function(self, ply, text)
		return PLUGIN:TTSUse(ply)
	end,
	OnRun = function(self, ply, text)
		if not PLUGIN:TTSUse(ply) then
			ply:Notify("I'm sorry, Dave. I'm afraid I can't let you do that without flags.")
			return
		end
		if not (ix.ttsvoice.begin == true) then
			local text = text or "error2"
			local encoded = PLUGIN:URLEncode(text)
			local url = ix.ttsvoice.url .. encoded
			local dist = ix.ttsvoice.range or 500
		
			for _, v in ipairs(player.GetAll()) do
				if v:GetPos():DistToSqr(ply:GetPos()) < (dist * dist) then -- Remember. This is their distance squared! Faster to call. :)
					net.Start("ix_ttsvoice_Play")
					net.WriteString(url)
					net.WriteEntity(ply)
					net.Send(v)
				end
			end
			
			ply:Say(text,false)
			ix.ttsvoice.begin = true
			timer.Simple(ix.ttsvoice.wait, function()
				ix.ttsvoice.begin = false
			end)
		else
			ply:Notify("Global Request Audio Time Exceeded. Wait a few seconds!")
		end
	end
})