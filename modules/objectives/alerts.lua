local _, Engine = ...
local Module = Engine:NewModule("Alerts")

-- WoW Frames & Objects
local AlertFrame = _G.AlertFrame

-- WoW Client Constants
local ENGINE_LEGION = Engine:IsBuild("Legion")

Module.OnInit = function(self)
end

Module.OnEnable = function(self)
	if AlertFrame then
		local anchor = Engine:CreateFrame("Frame", nil, "UICenter")
		anchor:SetSize(180,20)
		anchor:SetPoint("BOTTOM", 0, 220)

		AlertFrame:ClearAllPoints()
		AlertFrame:SetAllPoints(anchor)

		-- Just too many of this one popping up
		AlertFrame:UnregisterEvent("SHOW_LOOT_TOAST")
	end
end

