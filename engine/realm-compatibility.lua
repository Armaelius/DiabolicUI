--[[
	The MIT License (MIT)
	Copyright (c) 2017 Lars "Goldpaw" Norberg

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

-- Lua API
local _G = _G
local select = select
local tonumber = tonumber

-- WoW API
local GetBuildInfo = _G.GetBuildInfo
local GetRealmName = _G.GetRealmName
local hooksecurefunc = _G.hooksecurefunc


-- Retrive the current game client version
local BUILD = tonumber((select(2, GetBuildInfo()))) 

-- Retrieve the current realm name
local REALM = GetRealmName()


-- Fix the excessive "Not enough players" spam in Felsong battlegrounds
if (BUILD == 23420) and (REALM == "Felsong") then

	-- Lua API
	local _G = _G

	-- WoW API
	local GetMaxBattlefieldID = _G.GetMaxBattlefieldID
	local GetBattlefieldInstanceExpiration = _G.GetBattlefieldInstanceExpiration
	local GetBattlefieldStatus = _G.GetBattlefieldStatus
	local IsInInstance = _G.IsInInstance

	-- WoW Objects
	local PVPTimerFrame = _G.PVPTimerFrame

	hooksecurefunc("PVP_UpdateStatus", function() 
		local isInInstance, instanceType = IsInInstance()
		if (instanceType == "pvp") or (instanceType == "arena") then
			for i = 1, GetMaxBattlefieldID() do
				local status, mapName, teamSize, registeredMatch = GetBattlefieldStatus(i)
				if (status == "active") then
					PVPTimerFrame:SetScript("OnUpdate", nil)
					_G.BATTLEFIELD_SHUTDOWN_TIMER = 0 
				else
					local kickOutTimer = GetBattlefieldInstanceExpiration()
					if (kickOutTimer == 0) then
						PVPTimerFrame:SetScript("OnUpdate", nil)
						_G.BATTLEFIELD_SHUTDOWN_TIMER = 0 
					end 
				end
			end
		end
	end)

end