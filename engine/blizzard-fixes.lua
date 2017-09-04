
-- WoW API
local blizzardCollectgarbage = _G.collectgarbage

-- Retrive the current game client version
local BUILD = tonumber((select(2, GetBuildInfo()))) 

-- Shortcuts to identify client versions
local LEGION_730 = BUILD >= 24500 

-- Garbage collection is being overused and misused,
-- and it's causing lag and performance drops. 
blizzardCollectgarbage("setpause", 110)
blizzardCollectgarbage("setstepmul", 200)

_G.collectgarbage = function(opt, arg)
	if (opt == "collect") or (opt == nil) then
	elseif (opt == "count") then
		return blizzardCollectgarbage(opt, arg)
	elseif (opt == "setpause") then
		return blizzardCollectgarbage("setpause", 110)
	elseif opt == "setstepmul" then
		return blizzardCollectgarbage("setstepmul", 200)
	elseif (opt == "stop") then
	elseif (opt == "restart") then
	elseif (opt == "step") then
		if (arg ~= nil) then
			if (arg <= 10000) then
				return blizzardCollectgarbage(opt, arg)
			end
		else
			return blizzardCollectgarbage(opt, arg)
		end
	else
		return blizzardCollectgarbage(opt, arg)
	end
end

-- Memory usage is unrelated to performance, and tracking memory usage does not track "bad" addons.
-- Developers can uncomment this line to enable the functionality when looking for memory leaks, 
-- but for the average end-user this is a completely pointless thing to track. 
_G.UpdateAddOnMemoryUsage = function() end
