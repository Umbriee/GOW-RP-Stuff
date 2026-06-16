local PLUGIN = PLUGIN

PLUGIN.name = "Pac3 Patch"
PLUGIN.description = "Pac3 patch for derma something"
PLUGIN.author = "Umbree"
PLUGIN.schema = "Any"
PLUGIN.license = [[ --== No copyright. Copy, edit, update, do what you like. This is code was for one server and is open for all. ==-- ]]
-- print("--==[PAC3Patch] [Ver 1.5]==--")
-- print("[PAC3Patch] - Loading")
if CLIENT then
	-- print("[PAC3Patch] - Client applying.")
	local hasPatchedPACAddHook = false

	hook.Add("Think", "PAC3HookInterceptor", function()
		if not hasPatchedPACAddHook and pac and pac.AddHook then
			hasPatchedPACAddHook = true
			hook.Remove("Think", "PAC3HookInterceptor")

			local devCvar = GetConVar("developer")

			-- Backup original
			local originalAddHook = pac.AddHook

			function pac.AddHook(hookName, ident, func)
				if hookName == "Think" and type(ident) == "Panel" and IsValid(ident) then
					if devCvar and devCvar:GetInt() >= 2 then
						MsgC(Color(255, 100, 100), "[PAC3Patch] Blocked buggy Think hook on dropdown menu\n")
						MsgC(Color(255, 100, 100), "[PAC3Patch] --==Trace Start==--\n")
						debug.Trace()
						MsgC(Color(255, 100, 100), "[PAC3Patch] --==Trace End==--\n")
					end
					return -- Block the bad hook
				end

				-- Default behavior
				return originalAddHook(hookName, ident, func)
			end

			if devCvar and devCvar:GetInt() >= 2 then
				MsgC(Color(0, 255, 0), "[PAC3Patch] pac.AddHook override active.\n")
			end
		end
	end)
	-- print("[PAC3Patch] - Client applied.")
else
	-- print("[PAC3Patch] - Server applying.")
	-- print("[PAC3Patch] - Server applied.")
end
-- print("[PAC3Patch] - Loaded")
-- print("--==Have A Safe Day.==--")