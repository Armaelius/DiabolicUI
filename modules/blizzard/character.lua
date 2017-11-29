local ADDON, Engine = ...
local Module = Engine:NewModule("Blizzard: Character")
local C = Engine:GetDB("Data: Colors")

-- Lua API
local _G = _G
local pairs = pairs
local unpack = unpack

-- WoW API
local GetDetailedItemLevelInfo = _G.GetDetailedItemLevelInfo
local GetInventoryItemLink = _G.GetInventoryItemLink
local GetInventorySlotInfo = _G.GetInventorySlotInfo
local GetItemInfo = _G.GetItemInfo

-- WoW Client Constants
local ENGINE_LEGION = Engine:IsBuild("Legion")
local ENGINE_MOP = Engine:IsBuild("MoP")
local ENGINE_CATA = Engine:IsBuild("Cata")

Module.InitializePaperDoll = function(self)
	local config = self.config
	local buttonCache = {}
	local borderCache = {} -- Cache of custom old client borders
	
	-- The ItemsFrame was added in Cata when the character frame was upgraded to the big one
	local paperDoll = _G.PaperDollItemsFrame or _G.PaperDollFrame 

	for i = 1, select("#", paperDoll:GetChildren()) do
		local child = select(i, paperDoll:GetChildren())
		local childName = child:GetName()

		if (child:GetObjectType() == "Button") and (childName and childName:find("Slot")) then

			local itemLevel = child:CreateFontString()
			itemLevel:SetDrawLayer("OVERLAY")
			itemLevel:SetPoint(unpack(config.itemLevel.point))
			--itemLevel:SetFontObject(config.itemLevel.fontObject)
			itemLevel:SetFontObject(_G.NumberFont_Outline_Med or _G.NumberFontNormal) 
			itemLevel:SetFont(itemLevel:GetFont(), 14, "THINOUTLINE")

			itemLevel.shade = child:CreateTexture()
			itemLevel.shade:SetDrawLayer("ARTWORK")
			itemLevel.shade:SetTexture(config.itemLevel.shadeTexture)
			itemLevel.shade:SetPoint("TOPLEFT", itemLevel, "TOPLEFT", -6, 6)
			itemLevel.shade:SetPoint("BOTTOMRIGHT", itemLevel, "BOTTOMRIGHT", 6, -6)
			itemLevel.shade:SetAlpha(.5)

			buttonCache[child] = itemLevel

			--local normalTexture = _G[childName.."NormalTexture"] or child:GetNormalTexture()
			--if normalTexture then
			--	normalTexture:SetTexture("")
			--	normalTexture:SetAlpha(0)
			--	normalTexture:Hide()
			--end

			local iconBorder = child.IconBorder
			if (not iconBorder) then
				local iconBorder = child:CreateTexture()
				iconBorder:SetDrawLayer("ARTWORK")
				iconBorder:SetTexture([[Interface\Buttons\UI-Quickslot2]])
				iconBorder:SetAllPoints(normalTexture or child)
				iconBorder:Hide()

				local iconBorderDoubler = child:CreateTexture()
				iconBorderDoubler:SetDrawLayer("OVERLAY")
				iconBorderDoubler:SetAllPoints(iconBorder)
				iconBorderDoubler:SetTexture(iconBorder:GetTexture())
				iconBorderDoubler:SetBlendMode("ADD")
				iconBorderDoubler:Hide()

				hooksecurefunc(iconBorder, "SetVertexColor", function(_, ...) iconBorderDoubler:SetVertexColor(...) end)
				hooksecurefunc(iconBorder, "Show", function() iconBorderDoubler:Show() end)
				hooksecurefunc(iconBorder, "Hide", function() iconBorderDoubler:Hide() end)

				borderCache[child] = iconBorder
			end
		end
	end

	self.buttonCache = buttonCache
	self.borderCache = borderCache
end

Module.UpdateEquippeditemLevels = function(self, event, ...)

	if (event == "UNIT_INVENTORY_CHANGED") then
		local unit = ...
		if (unit ~= "player") then
			return 
		end
	end 

	for itemButton, itemLevel in pairs(self.buttonCache) do
		local normalTexture = _G[itemButton:GetName().."NormalTexture"] or itemButton:GetNormalTexture()
		if normalTexture then
			--normalTexture:SetVertexColor(unpack(C.General.UIBorder))
		end

		local slotID = itemButton:GetID()
		local itemLink = GetInventoryItemLink("player", slotID) 
		if itemLink then
			local _, _, itemRarity, ilvl = GetItemInfo(itemLink)
			if itemRarity then
				local effectiveLevel, previewLevel, origLevel = GetDetailedItemLevelInfo and GetDetailedItemLevelInfo(itemLink)
				ilvl = effectiveLevel or ilvl

				-- Legion Artifact offhanders report just the base itemLevel, without relic enhancements, 
				-- so we're borrowing the itemLevel from the main hand weapon when this happens.
				-- *The constants used are defined in FrameXML/Constants.lua
				if ENGINE_LEGION and (itemButton:GetID() == _G.INVSLOT_OFFHAND) and (itemRarity == 6) then 
					local mainHandLink = GetInventoryItemLink("player", _G.INVSLOT_MAINHAND)
					local _, _, mainHandRarity, mainHandLevel = GetItemInfo(mainHandLink)
					local effectiveLevel, previewLevel, origLevel = GetDetailedItemLevelInfo and GetDetailedItemLevelInfo(mainHandLink)

					mainHandLevel = effectiveLevel or mainHandLevel

					if (mainHandLevel and (mainHandLevel > ilvl)) and (mainHandRarity and (mainHandRarity == 6)) then
						ilvl = mainHandLevel
					end
				end 

				local r, g, b = unpack(C.Quality[itemRarity])
				itemLevel:SetTextColor(r, g, b)
				itemLevel.shade:SetVertexColor(r, g, b)
				itemLevel:SetText(ilvl or "")

				local iconBorder = itemButton.IconBorder
				if iconBorder then
					iconBorder:SetTexture([[Interface\Common\WhiteIconFrame]])
					if itemRarity then
						if (itemRarity >= (LE_ITEM_QUALITY_COMMON + 1)) and C.Quality[itemRarity] then
							iconBorder:Show()
							iconBorder:SetVertexColor(unpack(C.Quality[itemRarity]))
						else
							iconBorder:Show()
							iconBorder:SetVertexColor(unpack(C.General.UIOverlay))
						end
					else
						iconBorder:Hide()
					end
				else
					iconBorder = self.borderCache[itemButton]
					if iconBorder then
						if itemRarity then
							if (itemRarity >= (LE_ITEM_QUALITY_COMMON + 1)) and C.Quality[itemRarity] then
								iconBorder:Show()
								iconBorder:SetVertexColor(unpack(C.Quality[itemRarity]))
							else
								iconBorder:Show()
								iconBorder:SetVertexColor(unpack(C.General.UIBorder))
							end
						else
							iconBorder:Hide()
							iconBorder:Show()
							iconBorder:SetVertexColor(unpack(C.General.UIBorder))
						end
					end
				end

			else
				itemLevel:SetTextColor(1, 1, 0)
				itemLevel.shade:SetVertexColor(1, 1, 0)
			end
			if ilvl then
				itemLevel:SetText(ilvl)
				itemLevel.shade:Show()
			else
				itemLevel:SetText("")
				itemLevel.shade:Hide()
			end
		else
			local iconBorder = itemButton.IconBorder
			if iconBorder then
				iconBorder:Hide()
			else
				iconBorder = self.borderCache[itemButton]
				if iconBorder then
					iconBorder:Show()
					iconBorder:SetVertexColor(unpack(C.General.UIBorder))
				end
			end
			itemLevel:SetText("")
			itemLevel.shade:Hide()
		end	
	end

end

Module.OnInit = function(self)
	self.config = Engine:GetDB("Blizzard").character

	self:InitializePaperDoll()

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateEquippeditemLevels")
	if ENGINE_CATA then
		self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdateEquippeditemLevels")
		if ENGINE_MOP then
			self:RegisterEvent("ITEM_UPGRADE_MASTER_UPDATE", "UpdateEquippeditemLevels")
			self:RegisterEvent("ITEM_UPGRADE_MASTER_SET_ITEM", "UpdateEquippeditemLevels")
		end
	else
		self:RegisterEvent("UNIT_INVENTORY_CHANGED", "UpdateEquippeditemLevels")
	end
	
end
