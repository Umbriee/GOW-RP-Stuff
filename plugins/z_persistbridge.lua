local PLUGIN = PLUGIN

PLUGIN.name = "Persistance Bridge"
PLUGIN.description = "Put simply runs and self terminates a hook to the persist toolgun. Will it work? I 'unno."
PLUGIN.author = "Umbree"
PLUGIN.schema = "Any"
PLUGIN.license = [[ Bruh ]]

local PLUGIN = PLUGIN

hook.Add("InitPostEntity", "ixPersistBridge_Resolve", function()
	local persist = ix.plugin.Get("persistence")
	if persist and persist.stored then
		persist.DummyVar = 1337
		print("[PersistBridge] - Persistence plugin ready and is sending data")
		hook.Run("ixPersistenceReady", persist)
	end
end)