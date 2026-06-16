
ix.currency.symbol = "$"
ix.currency.singular = "Dollar"
ix.currency.plural = "Dollars"

ix.config.SetDefault("scoreboardRecognition", true)
ix.config.SetDefault("music", "music/hl2_song19.mp3")
ix.config.SetDefault("maxAttributes", 60)

ix.config.Add("rationDollars", 20, "The amount of Dollars that a person will get from a ration", nil, {
	data = {min = 0, max = 1000},
	category = "economy"
})

ix.config.Add("rationInterval", 300, "How long a person needs to wait in seconds to get their next ration", nil, {
	data = {min = 0, max = 86400},
	category = "economy"
})
