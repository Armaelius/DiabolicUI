local Addon, Engine = ...
local Module = Engine:NewModule("ChatFilters")

-- Lua API
local _G = _G

-- WoW API
local ChatFrame_AddMessageEventFilter = _G.ChatFrame_AddMessageEventFilter
local ChatFrame_RemoveMessageEventFilter = _G.ChatFrame_RemoveMessageEventFilter


Module.SetupRealmExceptions = ENGINE_LEGION_FELSONG and function(self)
end

Module.OnInit = function(self, event, ...)
	self.config = self:GetDB("ChatFilters") 
	self.db = self:GetConfig("ChatFilters") 
end

Module.OnEnable = function(self, event, ...)
end
