local Addon, Engine = ...
local Module = Engine:NewModule("ChatFilters")

-- Lua API
local _G = _G

-- WoW API
local ChatFrame_AddMessageEventFilter = _G.ChatFrame_AddMessageEventFilter
local ChatFrame_RemoveMessageEventFilter = _G.ChatFrame_RemoveMessageEventFilter
local GetMaxBattlefieldID = _G.GetMaxBattlefieldID
local GetBattlefieldInstanceExpiration = _G.GetBattlefieldInstanceExpiration
local GetBattlefieldStatus = _G.GetBattlefieldStatus
local GetRealmName = _G.GetRealmName
local hooksecurefunc = _G.hooksecurefunc
local IsInInstance = _G.IsInInstance


-- WoW Client Constants
local ENGINE_LEGION_FELSONG = Engine:IsBuild("7.1.5") and (not Engine:IsBuild("7.2.0")) and (GetRealmName() == "Felsong")

Module.SetupRealmExceptions = ENGINE_LEGION_FELSONG and function(self)
	-- Fix the excessive "Not enough players" spam in battlegrounds
	hooksecurefunc("PVP_UpdateStatus", function() 
		local isInInstance, instanceType = IsInInstance()
		if (instanceType == "pvp") or (instanceType == "arena") then
			for i = 1, GetMaxBattlefieldID() do
				local status, mapName, teamSize, registeredMatch = GetBattlefieldStatus(i)
				if (status == "active") then
					_G.PVPTimerFrame:SetScript("OnUpdate", nil)
					_G.BATTLEFIELD_SHUTDOWN_TIMER = 0 
				else
					local kickOutTimer = GetBattlefieldInstanceExpiration()
					if (kickOutTimer == 0) then
						_G.PVPTimerFrame:SetScript("OnUpdate", nil)
						_G.BATTLEFIELD_SHUTDOWN_TIMER = 0 
					end 
				end
			end
		end
	end)
end

Module.OnInit = function(self, event, ...)
	self.config = self:GetStaticConfig("ChatFilters") 
	self.db = self:GetConfig("ChatFilters") 
end

Module.OnEnable = function(self, event, ...)
	if Module.SetupRealmExceptions then
		Module:SetupRealmExceptions()
	end
end
