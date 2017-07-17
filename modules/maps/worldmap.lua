local _, Engine = ...
local Module = Engine:NewModule("Worldmap")

Module.OnInit = function(self)
	if BlackoutWorld then
		BlackoutWorld:SetAlpha(0)
	end
end 
