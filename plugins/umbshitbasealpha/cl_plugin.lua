local PLUGIN = PLUGIN
if CLIENT then
	local webaudioChan = {}
	webaudioChan.chan = nil
	webaudioChan.src = nil
	net.Receive("ix_ttsvoice_Play", function()
		local url = net.ReadString() or "error3"
		local source = net.ReadEntity()
		if source && url then
			print("[TTS] Downloading & playing Webaudio: "..url)
			sound.PlayURL(url, "3d", function(chan, err, errStr)
				if IsValid(chan) then
					local ply = source or (LocalPlayer())
					chan:SetPos(ply:GetPos())
					chan:SetVolume(4)
					chan:Play()
					webaudioChan.chan = chan
					webaudioChan.src = ply
				else
					local err,errStr = err or "NIL", errStr or "NIL"
					print("[TTS ERROR] ID: ".. err.." STR: "..errStr)
				end
			end)
		end
	end)
	hook.Add( "Think", "TTSVoicePlay", function()
		if webaudioChan && (webaudioChan.chan ~= nil) && (webaudioChan.src ~= nil) then
			--print("Chan = "..tostring(webaudioChan.chan).." src = "..tostring(webaudioChan.src))
			if webaudioChan.chan:IsValid() then
				webaudioChan.chan:SetPos(webaudioChan.src:GetPos())
			else
				webaudioChan.chan = nil
				webaudioChan.src = nil
			end
		end
	end)
end