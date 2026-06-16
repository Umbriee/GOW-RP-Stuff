local PLUGIN = PLUGIN

if CLIENT then
	local hud = PLUGIN.huddrawdata["cog"]
	hud.onHudDraw = function(client, char)
		print("huddraw",client,char)
	end
	hud.onCanDraw = function(client, char)
		print("candraw",client,char)
		return client:IsCog()
	end
else

end