 
ix.command.Add("AdminSpawnMenu", {
    adminOnly = true,
	OnRun = function(self, client)
		net.Start("adminSpawnMenu")
		net.Send(client)
	end
})