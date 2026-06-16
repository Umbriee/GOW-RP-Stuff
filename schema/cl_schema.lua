
function Schema:AddCombineDisplayMessage(text, color, ...)
	if (LocalPlayer():IsCOG() and IsValid(ix.gui.combine)) then
		ix.gui.combine:AddLine(text, color, nil, ...)
	end
end
