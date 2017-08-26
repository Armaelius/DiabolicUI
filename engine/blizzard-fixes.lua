
-- Garbage collection is being overused and misused,
-- and it's causing lag and performance drops. 
local oldcollectgarbage = _G.collectgarbage
oldcollectgarbage("setpause", 110)
oldcollectgarbage("setstepmul", 200)

_G.collectgarbage = function(opt, arg)
    if (opt == "collect") or (opt == nil) then
    elseif (opt == "count") then
        return oldcollectgarbage(opt, arg)
    elseif (opt == "setpause") then
        return oldcollectgarbage("setpause", 110)
    elseif opt == "setstepmul" then
        return oldcollectgarbage("setstepmul", 200)
    elseif (opt == "stop") then
    elseif (opt == "restart") then
    elseif (opt == "step") then
        if (arg ~= nil) then
            if (arg <= 10000) then
                return oldcollectgarbage(opt, arg)
            end
        else
            return oldcollectgarbage(opt, arg)
        end
    else
        return oldcollectgarbage(opt, arg)
    end
end

-- Memory usage is unrelated to performance, and tracking memory usage does not track "bad" addons.
-- Developers can uncomment this line to enable the functionality when looking for memory leaks, 
-- but for the average end-user this is a completely pointless thing to track. 
_G.UpdateAddOnMemoryUsage = function() end
