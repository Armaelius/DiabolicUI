local _, Engine = ...
local Module = Engine:NewModule("Alerts")

-- Lua API
local _G = _G
local string_gsub = string.gsub
local string_match = string.match

-- WoW Frames & Objects
local AlertFrame = _G.AlertFrame

-- WoW Client Constants
local ENGINE_LEGION = Engine:IsBuild("Legion")

local blacklist = {
	currency = {
		["1155"] = 10 -- Ancient Mana
	}
}

Module.OnEvent = function(self, event, ...)
	if (event == "SHOW_LOOT_TOAST") then
		local typeIdentifier, itemLink, quantity, specID, sex, isPersonal, lootSource, lessAwesome, isUpgraded = ...
		if (isPersonal and (typeIdentifier == "currency")) then
			if blacklist[typeIdentifier] then 
				local typeString = string_match(itemLink, typeIdentifier.."[%-?%d:]+")
				if typeString then 
					local typeID = string_gsub(typeString, typeIdentifier..":(%d+)", "%1")
					local blockCount = typeID and blacklist[typeIdentifier][typeID]
					if blockCount then 
						if (blockCount == true) or ((quantity or 0) < blockCount) then 
							return 
						end 
					end
				end 
			end 
		end
	end
	-- Just proxy this to the original frame and eventhandler if not blocked
	return AlertFrame:GetScript("OnEvent")(AlertFrame, event, ...)
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

		-- Register our own, to control what is shown
		self:RegisterEvent("SHOW_LOOT_TOAST", "OnEvent")
	end
end

