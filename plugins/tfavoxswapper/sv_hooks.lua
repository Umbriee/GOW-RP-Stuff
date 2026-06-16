local PLUGIN = PLUGIN
local savelocation = "umco_tfavox"
--==[ SAVE ]==--
function PLUGIN:SaveVox()
	data = self.voxtable or {}
	ix.data.Set(savelocation, data, false, true)
end
--==[ LOAD ]==--
function PLUGIN:LoadVox()
	local vox = ix.data.Get(savelocation)
	self.voxtable = vox or {}
end
--==[ HELIX ]==--
function PLUGIN:SaveData()
	self:SaveVox()
end
function PLUGIN:LoadData()
	self:LoadVox()
end