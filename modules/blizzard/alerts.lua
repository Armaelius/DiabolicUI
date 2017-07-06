local _, Engine = ...
local Module = Engine:NewModule("BlizzardAlerts")

Module.OnInit = function(self)
	self:GetHandler("BlizzardUI"):GetElement("Alerts"):Disable()
end
