local _, Engine = ...
local Module = Engine:NewModule("Worldmap")

-- Lua API
local _G = _G

-- WoW Frames & Objects
local WorldMapDetailFrame = _G.WorldMapDetailFrame

Module.OnInit = function(self)
end 

Module.OnEnable = function(self)
	-- Kill off the black background around the fullscreen worldmap, 
	-- so that we can see at least a little of what's going on.
	local BlizzardUI = self:GetHandler("BlizzardUI")
	BlizzardUI:GetElement("WorldMap"):Remove("BlackoutWorld")

	if WorldMapDetailFrame then
		WorldMapDetailFrame:SetAlpha(.75)
		
		local overlayTexture = WorldMapDetailFrame:CreateTexture(nil, "OVERLAY")
		overlayTexture:SetAllPoints()
		overlayTexture:SetColorTexture(.15,.1,.05,.35)
	end

end