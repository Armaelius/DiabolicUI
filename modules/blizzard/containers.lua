local ADDON, Engine = ...
local Module = Engine:NewModule("Blizzard: Containers")
local C = Engine:GetStaticConfig("Data: Colors")

-- Lua API
local _G = _G
local string_match = string.match
local tonumber = tonumber

-- WoW API
local CreateFrame = _G.CreateFrame
local GetContainerItemInfo = _G.GetContainerItemInfo
local GetContainerItemQuestInfo = _G.GetContainerItemQuestInfo
local GetItemInfo = _G.GetItemInfo
local GetItemQualityColor = _G.GetItemQualityColor
local IsArtifactRelicItem = _G.IsArtifactRelicItem

local itemLevelCache = {} -- Cache of itemlevel texts
local newItemCache = {} -- Cache of new item flash textures
local borderCache = {} -- Cache of custom old client borders

Module.OnInit = function(self)

	local currentContainer = 1
	local container = _G["ContainerFrame"..currentContainer]
	while container do 
		local currentItem = 1
		local item = _G["ContainerFrame"..currentContainer.."Item"..currentItem]
		while item do 
			local buttonName = item:GetName()

			-- Tone down the over emphasized texture for flashing new items
			--
			-- *Note that this is for default Blizzard bags only, 
			--  the user still has to manually disable new item  
			--  flashing in third party addons like Bagnon.
			local newItemTexture = item.NewItemTexture
			if newItemTexture then
				local proxy = CreateFrame("Frame", nil, newItemTexture:GetParent())
				proxy:SetAllPoints()
				newItemTexture:SetParent(proxy)
				newItemTexture:SetAlpha(.25)
				newItemCache[item] = proxy
			end

			local normalTexture = _G[buttonName.."NormalTexture"] or itemButton:GetNormalTexture()
			if normalTexture then
				normalTexture:Hide()
				normalTexture:SetAlpha(0)
			end

			local iconBorder = item.IconBorder
			if (not iconBorder) then
				local iconBorder = item:CreateTexture()
				iconBorder:SetDrawLayer("ARTWORK")
				iconBorder:SetTexture([[Interface\Buttons\UI-Quickslot2]])
				iconBorder:SetAllPoints(normalTexture or item)
				iconBorder:Hide()

				local iconBorderDoubler = item:CreateTexture()
				iconBorderDoubler:SetDrawLayer("OVERLAY")
				iconBorderDoubler:SetAllPoints(iconBorder)
				iconBorderDoubler:SetTexture(iconBorder:GetTexture())
				iconBorderDoubler:SetBlendMode("ADD")
				iconBorderDoubler:Hide()

				hooksecurefunc(iconBorder, "SetVertexColor", function(_, ...) iconBorderDoubler:SetVertexColor(...) end)
				hooksecurefunc(iconBorder, "Show", function() iconBorderDoubler:Show() end)
				hooksecurefunc(iconBorder, "Hide", function() iconBorderDoubler:Hide() end)

				borderCache[item] = iconBorder
			end

			currentItem = currentItem + 1
			item = _G["ContainerFrame"..currentContainer.."Item"..currentItem]
		end
		currentContainer = currentContainer + 1
		container = _G["ContainerFrame"..currentContainer]

	end

	if _G.ContainerFrame_Update then
		hooksecurefunc("ContainerFrame_Update", function(frame) 
			local bagID = frame:GetID()
			local name = frame:GetName()

			for i = 1, frame.size, 1 do

				local buttonName = name.."Item"..i
				local itemButton = _G[buttonName]
				local slotID = itemButton:GetID()

				local texture, itemCount, locked, itemRarity, readable, _, _, isFiltered, noValue, itemID = GetContainerItemInfo(bagID, slotID)
				local isQuestItem, questId, isActive = GetContainerItemQuestInfo(bagID, slotID)
				local itemLink = GetContainerItemLink(bagID, slotID)

				local iconBorder = itemButton.IconBorder
				if iconBorder then
					iconBorder:SetTexture([[Interface\Common\WhiteIconFrame]])
					if itemRarity then
						if (itemRarity >= (LE_ITEM_QUALITY_COMMON + 1)) and C.Quality[itemRarity-1] then
							iconBorder:Show()
							iconBorder:SetVertexColor(unpack(C.Quality[itemRarity-1]))
						else
							iconBorder:Show()
							iconBorder:SetVertexColor(unpack(C.General.UIBorder))
						end
					else
						iconBorder:Hide()
					end
				else
					iconBorder = borderCache[itemButton]
					if iconBorder then
						if itemRarity then
							if (itemRarity >= (LE_ITEM_QUALITY_COMMON + 1)) and C.Quality[itemRarity-1] then
								iconBorder:Show()
								iconBorder:SetVertexColor(unpack(C.Quality[itemRarity-1]))
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

				local iconTexture = buttonName and _G[buttonName.."IconTexture"]
				if iconTexture then
					if itemRarity and (itemRarity < LE_ITEM_QUALITY_COMMON) and (itemRarity > -1) then
						iconTexture:SetDesaturated(true)
						iconTexture:SetVertexColor(unpack(C.General.UIBackdrop))
					else
						iconTexture:SetDesaturated(false)
						iconTexture:SetVertexColor(1, 1, 1)
					end
					if itemRarity and (itemRarity < (LE_ITEM_QUALITY_COMMON + 1)) and (itemRarity > -1) then
						if newItemCache[itemButton] then
							newItemCache[itemButton]:Hide()
						end
					else
						if newItemCache[itemButton] then
							newItemCache[itemButton]:Show()
						end
					end
				end

				-- Tone down the quest item and quest starter overlays, 
				-- as they are a bit too bright for my taste.				
				local questTexture = _G[name.."Item"..i.."IconQuestTexture"]
					if questId and not isActive then 
						questTexture:SetDrawLayer("ARTWORK")
						questTexture:SetAlpha(1)
						questTexture:SetTexCoord(10/64, 54/64, 10/64, 54/64)
						questTexture:ClearAllPoints()
						questTexture:SetPoint("TOPLEFT",6,-6)
						questTexture:SetPoint("BOTTOMRIGHT",-6,6)
						local iconBorder = iconBorder or borderCache[itemButton]
						if iconBorder then 
							iconBorder:Show()
							iconBorder:SetVertexColor(unpack(C.General.Gold))
						end
					elseif questId or isQuestItem then
						questTexture:Hide()
						local iconBorder = iconBorder or borderCache[itemButton]
						if iconBorder then 
							iconBorder:Show()
							iconBorder:SetVertexColor(unpack(C.General.Gold))
						end
					else
						questTexture:Hide()
					end

				if itemLink then
					local _, _, itemRarity, iLevel, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)

					if (not itemLevelCache[itemButton]) then

						-- Adding an extra layer to get it above glow and border textures
						local holder = CreateFrame("Frame", nil, itemButton)
						holder:SetAllPoints()

						-- Using standard blizzard fonts here
						local itemLevel = holder:CreateFontString()
						itemLevel:SetDrawLayer("ARTWORK")
						itemLevel:SetPoint("TOPLEFT", 4, -4)
						itemLevel:SetFontObject(_G.NumberFont_Outline_Med or _G.NumberFontNormal) 
						itemLevel:SetFont(itemLevel:GetFont(), 14, "OUTLINE")
						itemLevel:SetShadowOffset(1, -1)
						itemLevel:SetShadowColor(0, 0, 0, .5)

						itemLevelCache[itemButton] = itemLevel
					end

					-- Display item level of equippable gear and artifact relics
					if (itemRarity and (itemRarity >= (LE_ITEM_QUALITY_COMMON + 1))) and ((itemEquipLoc and _G[itemEquipLoc]) or (itemID and IsArtifactRelicItem and IsArtifactRelicItem(itemID))) then
						local r, g, b = GetItemQualityColor(itemRarity)
						itemLevelCache[itemButton]:SetTextColor(r, g, b)
						itemLevelCache[itemButton]:SetText(iLevel or "")
					else
						itemLevelCache[itemButton]:SetText("")
					end
				else
					if itemLevelCache[itemButton] then
						itemLevelCache[itemButton]:SetText("")
					end
				end

			end
		end)
	end
end
