local _, Engine = ...
local Module = Engine:NewModule("Worldmap")

Module.OnInit = function(self)
end 

Module.OnEnable = function(self)
	-- Kill off the black background around the fullscreen worldmap, 
	-- so that we can see at least a little of what's going on.
	local BlizzardUI = self:GetHandler("BlizzardUI")
	BlizzardUI:GetElement("WorldMap"):Remove("BlackoutWorld")
end