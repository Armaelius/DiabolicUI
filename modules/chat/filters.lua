local Addon, Engine = ...
local Module = Engine:NewModule("ChatFilters")

-- Bail if Prat is enabled
Module:SetIncompatible("Prat-3.0")

Module.OnInit = function(self, event, ...)
	self.config = self:GetStaticConfig("ChatFilters") -- setup
	self.db = self:GetConfig("ChatFilters") -- user settings
end

Module.OnEnable = function(self, event, ...)
end

Module.OnDisable = function(self)
end
