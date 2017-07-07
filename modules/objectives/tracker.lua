local _, Engine = ...
local Module = Engine:NewModule("ObjectiveTracker")
local L = Engine:GetLocale()
local C = Engine:GetStaticConfig("Data: Colors")
--local QuestZones = Engine:GetStaticConfig("Data: QuestZones") -- not currently in use
local UICenter = Engine:GetFrame()

-- Lua API
local _G = _G
local bit_band = bit.band
local ipairs = ipairs
local math_abs = math.abs
local math_floor = math.floor
local math_huge = math.huge
local math_sqrt = math.sqrt
local pairs = pairs
local rawget = rawget
local select = select
local setmetatable = setmetatable
local string_match = string.match
local string_gmatch = string.gmatch
local string_gsub = string.gsub
local string_lower = string.lower
local string_upper = string.upper
local table_insert = table.insert
local table_remove = table.remove
local table_sort = table.sort
local table_wipe = table.wipe
local tonumber = tonumber
local unpack = unpack

-- WoW API
local AddQuestWatch = _G.AddQuestWatch
local AddWorldQuestWatch = _G.AddWorldQuestWatch
local C_TaskQuest = _G.C_TaskQuest
local ChatEdit_GetActiveWindow = _G.ChatEdit_GetActiveWindow
local ChatEdit_InsertLink = _G.ChatEdit_InsertLink
local CloseDropDownMenus = _G.CloseDropDownMenus
local GetAuctionItemClasses = _G.GetAuctionItemClasses
local GetAuctionItemSubClasses = _G.GetAuctionItemSubClasses
local GetAutoQuestPopUp = _G.GetAutoQuestPopUp
local GetCurrentMapAreaID = _G.GetCurrentMapAreaID
local GetCVarBool = _G.GetCVarBool
local GetDistanceSqToQuest = _G.GetDistanceSqToQuest
local GetFactionInfoByID = _G.GetFactionInfoByID
local GetItemSubClassInfo = _G.GetItemSubClassInfo
local GetMapNameByID = _G.GetMapNameByID
local GetMoney = _G.GetMoney
local GetNumAutoQuestPopUps = _G.GetNumAutoQuestPopUps
local GetNumQuestLeaderBoards = _G.GetNumQuestLeaderBoards
local GetNumQuestLogEntries = _G.GetNumQuestLogEntries
local GetNumQuestWatches = _G.GetNumQuestWatches
local GetNumWorldQuestWatches = _G.GetNumWorldQuestWatches
local GetPlayerMapPosition = _G.GetPlayerMapPosition
local GetProfessions = _G.GetProfessions
local GetQuestDifficultyColor = _G.GetQuestDifficultyColor
local GetQuestID = _G.GetQuestID
local GetQuestLogCompletionText = _G.GetQuestLogCompletionText
local GetQuestLogIndexByID = _G.GetQuestLogIndexByID
local GetQuestLogQuestText = _G.GetQuestLogQuestText
local GetQuestLogRequiredMoney = _G.GetQuestLogRequiredMoney
local GetQuestLogSelection = _G.GetQuestLogSelection
local GetQuestLogSpecialItemInfo = _G.GetQuestLogSpecialItemInfo
local GetQuestLogTitle = _G.GetQuestLogTitle
local GetQuestObjectiveInfo = _G.GetQuestObjectiveInfo
local GetQuestProgressBarPercent = _G.GetQuestProgressBarPercent
local GetQuestTagInfo = _G.GetQuestTagInfo
local GetQuestWatchInfo = _G.GetQuestWatchInfo
local GetQuestWorldMapAreaID = _G.GetQuestWorldMapAreaID
local GetSuperTrackedQuestID = _G.GetSuperTrackedQuestID
local GetTaskInfo = _G.GetTaskInfo
local GetWorldQuestWatchInfo = _G.GetWorldQuestWatchInfo
local HaveQuestData = _G.HaveQuestData
local IsModifiedClick = _G.IsModifiedClick
local IsQuestBounty = _G.IsQuestBounty
local IsQuestInvasion = _G.IsQuestInvasion
local IsQuestTask = _G.IsQuestTask
local IsQuestWatched = _G.IsQuestWatched
local IsWorldQuestWatched = _G.IsWorldQuestWatched
local PlaySound = _G.PlaySound
local QuestGetAutoAccept = _G.QuestGetAutoAccept
local QuestHasPOIInfo = _G.QuestHasPOIInfo
local QuestLog_OpenToQuest = _G.QuestLog_OpenToQuest
local QuestLogPopupDetailFrame_Show = _G.QuestLogPopupDetailFrame_Show
local QuestMapFrame_IsQuestWorldQuest = _G.QuestMapFrame_IsQuestWorldQuest
local QuestUtils_IsQuestWorldQuest = _G.QuestUtils_IsQuestWorldQuest
local RemoveQuestWatch = _G.RemoveQuestWatch
local RemoveWorldQuestWatch = _G.RemoveWorldQuestWatch
local SelectQuestLogEntry = _G.SelectQuestLogEntry
local SetMapToCurrentZone = _G.SetMapToCurrentZone
local SetSuperTrackedQuestID = _G.SetSuperTrackedQuestID
local ShowQuestComplete = _G.ShowQuestComplete
local ShowQuestOffer = _G.ShowQuestOffer
local UnitAffectingCombat = _G.UnitAffectingCombat
local WorldMap_GetWorldQuestRewardType = _G.WorldMap_GetWorldQuestRewardType

-- WoW Frames
local QuestFrame = _G.QuestFrame
local QuestFrameAcceptButton = _G.QuestFrameAcceptButton
local QuestFrameRewardPanel = _G.QuestFrameRewardPanel
local WorldMapFrame = _G.WorldMapFrame

-- Copied from WorldMapFrame.lua in Legion
local WQ = {
	WORLD_QUEST_REWARD_TYPE_FLAG_GOLD = _G.WORLD_QUEST_REWARD_TYPE_FLAG_GOLD, -- 0x0001
	WORLD_QUEST_REWARD_TYPE_FLAG_ORDER_RESOURCES = _G.WORLD_QUEST_REWARD_TYPE_FLAG_ORDER_RESOURCES, -- 0x0002
	WORLD_QUEST_REWARD_TYPE_FLAG_ARTIFACT_POWER = _G.WORLD_QUEST_REWARD_TYPE_FLAG_ARTIFACT_POWER, -- 0x0004
	WORLD_QUEST_REWARD_TYPE_FLAG_MATERIALS = _G.WORLD_QUEST_REWARD_TYPE_FLAG_MATERIALS, -- 0x0008
	WORLD_QUEST_REWARD_TYPE_FLAG_EQUIPMENT = _G.WORLD_QUEST_REWARD_TYPE_FLAG_EQUIPMENT -- 0x0010

}
	
-- Lua enums used to identify various types of Legion world quests
local LE = {
	LE_QUEST_TAG_TYPE_INVASION = _G.LE_QUEST_TAG_TYPE_INVASION,
	LE_QUEST_TAG_TYPE_DUNGEON = _G.LE_QUEST_TAG_TYPE_DUNGEON,
	LE_QUEST_TAG_TYPE_RAID = _G.LE_QUEST_TAG_TYPE_RAID,
	LE_WORLD_QUEST_QUALITY_RARE = _G.LE_WORLD_QUEST_QUALITY_RARE,
	LE_WORLD_QUEST_QUALITY_EPIC = _G.LE_WORLD_QUEST_QUALITY_EPIC,
	LE_QUEST_TAG_TYPE_PVP = _G.LE_QUEST_TAG_TYPE_PVP,
	LE_QUEST_TAG_TYPE_PET_BATTLE = _G.LE_QUEST_TAG_TYPE_PET_BATTLE,
	LE_QUEST_TAG_TYPE_PROFESSION = _G.LE_QUEST_TAG_TYPE_PROFESSION,
	LE_ITEM_QUALITY_COMMON = _G.LE_ITEM_QUALITY_COMMON
}

-- Client Constants
local ENGINE_LEGION 	= Engine:IsBuild("Legion")
local ENGINE_WOD 		= Engine:IsBuild("WoD")
local ENGINE_MOP 		= Engine:IsBuild("MoP")
local ENGINE_CATA 		= Engine:IsBuild("Cata")

-- 	Tracking quest zones is a tricky thing, since the map needs to be changed  
-- 	to the current zone in order to retrieve that information about regular quests. 
-- 	However, doing this while the worldmap is open will lock it to the current zone, 
--  preventing the user from changing the visible zone. 
-- 	
-- 	So in order to minimize the impact on the game experience, avoid overriding player choices related to the visible map zone, 
-- 	and also allow us to view quests from other zones in the tracker depending on what zone the visible map is set to, 
-- 	we track both the actual player zone and the current map zone individually.
local CURRENT_PLAYER_ZONE -- The zone the player is in, updated upon entering the world, and zone changes
local CURRENT_MAP_ZONE -- The zone the world map is set to, updated on map display and map zone changes
local CURRENT_PLAYER_X, CURRENT_PLAYER_Y -- Tracking player position when the map isn't set to the current zone
local PIXEL_SIZE -- Constant to attempt to track the virtual size of an on-screen pixel

local questData = {} -- quest status and objectives by questID 

local allTrackedQuests = {} -- all tracked quests
local zoneTrackedQuests = {} -- quests auto tracked by zone
local userTrackedQuests = {} -- quests manually tracked by the user

local sortedTrackedQuests = {} -- indexed table with the currently tracked quests sorted
local trackedQuestsByQuestID = {} -- a fast lookup table to decide if a quest is visible
local questWatchQueue = {} -- temporary cache for quests to be tracked
local worldQuestWatchQueue = {} -- temporary cache for world quests to be tracked

local questLogCache = {} -- cache of the current questlog
local worldQuestCache = {} -- cache of the current world quests

local itemButtons = {} -- item button cache, mostly for easier naming
local activeItemButtons = {} -- cache of active and visible item buttons
local backdropCache = {} -- Cachce of pixel perfect backdrops we need to keep updated on scale changes

-- Broken Isles zones 
-- used to parse for available world quests.
local brokenIslesContinent = 1007 -- Broken Isles (The whole continent)
local brokenIslesZones = {
	1015,	-- Aszuna
	1021,	-- Broken Shore
	1014,	-- Dalaran
	1098,	-- Eye of Azshara
	1024,	-- Highmountain
	1017,	-- Stormheim
	1033,	-- Suramar
	1018	-- Val'sharah
}

-- Create a faster lookup table to figure out if we're in a Legion outdoors zone
-- We're including the main continent map in this lookup table too, 
-- since we're using this table to decide whether or not to scan world quests. 
local isLegionZone = { [brokenIslesContinent] = true }
for _,zoneID in pairs(brokenIslesZones) do
	isLegionZone[zoneID] = true
end

-- Order Hall zones
-- *Note that Death Knights, Paladins, Rogues and Warlocks 
--  have order halls that either are inside existing cities 
--  or instanced zones not part of the broken isles, 
--  and therefore aren't needed in this list. 
local orderHallZones = {
	1052,	-- Mardum, the Shattered Abyss		Demon Hunter
	1077,	-- The Dreamgrove					Druid
	1072,	-- Trueshot Lodge					Hunter
	1068,	-- Hall of the Guardian				Mage
	1044,	-- The Wandering Isle				Monk
	1040,	-- Netherlight Temple				Priest
	1057,	-- The Heart of Azeroth				Shaman
	1035	-- Skyhold							Warrior
}

-- Legion Raids 
local legionRaids = {
	1094,	-- The Emerald Nightmare
	1114,	-- Trial of Valor
	1088,	-- The Nighthold
	1147	-- Tomb of Sargeras
}

-- Legion Dungeons
local legionDungeons = {
	1081,	-- Black Rook Hold
	1146,	-- Cathedral of Eternal Night
	1087,	-- Court of Stars
	1067,	-- Darkheart Thicket
	1046,	-- Eye of Azshara
	1041,	-- Halls of Valor
	1042,	-- Maw of Souls
	1065,	-- Neltharion's Lair
	1115,	-- Return to Karazhan
	1079,	-- The Arcway
	1045,	-- Vault of the Wardens
	1066	-- Violet Hold
}

-- Localized Blizzard strings
local BLIZZ_LOCALE = {
	ACCEPT = _G.ACCEPT,
	COMPLETE = _G.COMPLETE,
	COMPLETE_QUEST = _G.COMPLETE_QUEST,
	CONTINUE = _G.CONTINUE,
	FAILED = _G.FAILED,
	NEW = _G.NEW,
	OBJECTIVES = _G.OBJECTIVES_TRACKER_LABEL,
	QUEST_COMPLETE = _G.QUEST_WATCH_QUEST_READY or _G.QUEST_WATCH_QUEST_COMPLETE or _G.QUEST_COMPLETE,
	QUEST_FAILED = _G.QUEST_FAILED,
	QUEST = ENGINE_LEGION and GetItemSubClassInfo(_G.LE_ITEM_CLASS_QUESTITEM, (select(1, GetAuctionItemSubClasses(_G.LE_ITEM_CLASS_QUESTITEM)))) or ENGINE_CATA and (select(10, GetAuctionItemClasses())) or (select(12, GetAuctionItemClasses())) or "Quest", -- the fallback isn't actually needed
	UPDATE = _G.UPDATE
}

-- Blizzard textures 
local TEXTURE = {
	BLANK = [[Interface\ChatFrame\ChatFrameBackground]],
	BLING = [[Interface\Cooldown\star4]],
	EDGE_LOC = [[Interface\Cooldown\edge-LoC]],
	EDGE_NORMAL = [[Interface\Cooldown\edge]]
}

-- We'll create search patterns from these later on, 
-- to better parse quest objectives and figure out what we need, 
-- what has changed, what events to look out for and so on. 
-- 
--	QUEST_SUGGESTED_GROUP_NUM = "Suggested Players [%d]";
--	QUEST_SUGGESTED_GROUP_NUM_TAG = "Group: %d";
--	QUEST_FACTION_NEEDED = "%s:  %s / %s";
--	QUEST_ITEMS_NEEDED = "%s: %d/%d";
--	QUEST_MONSTERS_KILLED = "%s slain: %d/%d";
--	QUEST_OBJECTS_FOUND = "%s: %d/%d";
--	QUEST_PLAYERS_KILLED = "Players slain: %d/%d";
--	QUEST_FACTION_NEEDED_NOPROGRESS = "%s:  %s";
--	QUEST_INTERMEDIATE_ITEMS_NEEDED = "%s: (%d)";
--	QUEST_ITEMS_NEEDED_NOPROGRESS = "%s x %d";
--	QUEST_MONSTERS_KILLED_NOPROGRESS = "%s x %d";
--	QUEST_OBJECTS_FOUND_NOPROGRESS = "%s x %d";
--	QUEST_PLAYERS_KILLED_NOPROGRESS = "Players x %d";
-- 
local questCaptures = setmetatable({
	item 		= string_gsub(string_gsub("^" .. _G.QUEST_ITEMS_NEEDED, 	"%%[0-9%$]-s", "(.-)"), "%%[0-9%$]-d", "(%%d+)"),
	monster 	= string_gsub(string_gsub("^" .. _G.QUEST_MONSTERS_KILLED, 	"%%[0-9%$]-s", "(.-)"), "%%[0-9%$]-d", "(%%d+)"),
	faction 	= string_gsub(string_gsub("^" .. _G.QUEST_FACTION_NEEDED, 	"%%[0-9%$]-s", "(.-)"), "%%[0-9%$]-d", "(%%d+)"),
	reputation 	= string_gsub(string_gsub("^" .. _G.QUEST_FACTION_NEEDED, 	"%%[0-9%$]-s", "(.-)"), "%%[0-9%$]-d", "(%%d+)"),
	unknown 	= string_gsub(string_gsub("^" .. _G.QUEST_OBJECTS_FOUND, 	"%%[0-9%$]-s", "(.-)"), "%%[0-9%$]-d", "(%%d+)")
}, { __index = function(self) return rawget(self, "unknown") end})



-- Utility functions and stuff
-----------------------------------------------------
-- Strip a string of its line breaks
local stripString = function(msg)
	if (not msg) then
		return ""
	end
	msg = string_gsub(msg, "\|n", "")
	msg = string_gsub(msg, "|n", "")
	return msg
end

-- Capitalize the first letter in each word
local titleCase = function(first, rest) return string_upper(first)..string_lower(rest) end
local capitalizeString = function(msg)
	return string_gsub(msg or "", "(%a)([%w_']*)", titleCase)
end


-- Parse a string for info about sizes and words.
-- The fontString should be set to a LARGE size before doing this. 
local parseString = function(msg, fontString, words, wordWidths)
	words = words and table_wipe(words) or {}
	wordWidths = wordWidths and table_wipe(wordWidths) or {}

	-- Retrieve the dummyString for calculations
	local dummyString = fontString.dummyString

	-- Get the width of the full string
	dummyString:SetText(msg)
	local fullWidth = math_floor(dummyString:GetStringWidth() + .5)

	-- Get the width of a single space character
	dummyString:SetText(" ")
	local spaceWidth = math_floor(dummyString:GetStringWidth() + .5)

	-- Split the string into words
	for word in  string_gmatch(msg, "%S+") do 
		words[#words + 1] = word
	end

	-- Calculate word word widths
	for i in ipairs(words) do
		dummyString:SetText(words[i])
		wordWidths[i] = math_floor(dummyString:GetStringWidth() + .5)
	end

	-- Return sized and tables 
	return fullWidth, spaceWidth, wordWidths, words
end

-- A little magic to at least attempt 
-- to keep the pixel borders locked to actual pixels. 
--
-- This will fail if the user has manually resized the window 
-- to a size not matching the chosen resolution, 
-- or if the window is maximized when the chosen resolution
-- does not match the actual screen resolution. 
-- 
-- There's no workaround for those cases, as WoW simply 
-- does't provide any API to retrieve the actual sizes with.
--
-- Eventually I'll make a nice border texture that scales well, 
-- but for now we're doing it this way. 
local getPixelPerfectBackdrop = function()
	local pixelSize = UICenter:GetSizeOfPixel()
	return {
		bgFile = TEXTURE.BLANK,
		edgeFile = TEXTURE.BLANK,
		edgeSize = pixelSize,
		insets = {
			left = -pixelSize,
			right = -pixelSize,
			top = -pixelSize,
			bottom = -pixelSize
		}
	}
end

-- Set a message and calculate it's best size for display.
-- *The excessive amount of comments here is because my brain 
-- turns to mush when working with scripts like this, 
-- and without them I just keep messing things up. 
-- I guess my near photographic memory from my teenage years is truly dead. :'(
local dummy = Engine:CreateFrame("Frame", nil, "UICenter")
dummy:Place("TOP", "UICenter", "BOTTOM", 0, -1000)
dummy:SetSize(2,2)

local setTextAndGetSize = function(fontString, msg, minWidth, minHeight)
	fontString:Hide() -- hide the madness we're about to do

	local lineSpacing = fontString:GetSpacing()
	local newHeight, newMsg

	-- Get rid of line breaks, we're making our own later on instead.
	msg = capitalizeString(stripString(msg))

	local dummyString = fontString.dummyString 
	if (not dummyString) then
		dummyString = dummy:CreateFontString()
		dummyString:Hide()
		dummyString:SetFontObject(fontString:GetFontObject())
		dummyString:SetPoint("TOP", 0, 0)
		fontString.dummyString = dummyString
	end
	dummyString:SetSize(minWidth*10, minHeight*10 + lineSpacing*9)
	--dummyString:Show() -- need to show it to properly calculate sizes, even though it is offscreen

	-- Parse the string, split into words and calculate all sizes 
	fontString.fullWidth, fontString.spaceWidth, fontString.wordWidths, 
	fontString.words = parseString(msg, fontString, fontString.words, fontString.wordWidths)

	--dummyString:Hide()

	-- Because Blizzard keeps changing 20 to 19.9999995
	-- We also need an extra space's width to avoid the strings
	-- getting truncated in Legion. Because large enough isn't large enough anymore. /sigh
	minWidth = math_floor(minWidth + .5 + fontString.spaceWidth)

	local wordsPerLine = table_wipe(fontString.wordsPerLine or {})

	-- Figure out the height and lines of the text
	if fontString.fullWidth > minWidth then
		local currentWidth = 0
		local currentLineWords = 0

		-- Figure out the minimum number of lines
		local numLines = 1
		for i in ipairs(fontString.wordWidths) do
			-- Retrieve the length of the next word
			local nextWordWidth = fontString.wordWidths[i]

			-- see if it's space for the current word, if not start a new line
			if ((currentWidth + nextWordWidth) > minWidth) then

				-- Store the number of words on the current line
				wordsPerLine[numLines] = currentLineWords

				-- Increase the line counter, as one more is needed
				numLines = numLines + 1
				
				-- Reset the width of the current line, as we're starting a new one
				currentWidth = 0

				-- Reset the number of words on the current line, as we're starting a new one
				currentLineWords = 0
			end

			-- Add the width of the current word to the length of the current line
			currentWidth = currentWidth + nextWordWidth

			-- Add the current word to the current line's word count
			currentLineWords = currentLineWords + 1

			-- are there more words, if so should we break or continue?
			if (i < #fontString.wordWidths) then

				-- see if there's room for a space, if not we start a new line
				if (currentWidth + fontString.spaceWidth) > minWidth then
					-- Store the number of words on the current line
					wordsPerLine[numLines] = currentLineWords

					-- Increase the line counter, as one more is needed
					numLines = numLines + 1
					
					-- Reset the width of the current line, as we're starting a new one
					currentWidth = 0

					-- Reset the number of words on the current line, as we're starting a new one
					currentLineWords = 0

				else
					-- We have room for a space character, so we add one.
					currentWidth = currentWidth + fontString.spaceWidth
				end
			else
				-- Last word, so store the number of words on this line now, 
				-- as this loop won't run again and it feels clunky adding it afterwords. :)
				wordsPerLine[numLines] = currentLineWords
			end
		end

		-- Store the table with the number of words per line in the fontstring
		fontString.wordsPerLine = wordsPerLine

		-- Figure out if the last line has so few words it looks weird
		if (numLines > 1) then
			local wordsOnLastLine = fontString.wordsPerLine[numLines]
			local wordsOnSecondToLastLine = fontString.wordsPerLine[numLines - 1]
			local lastWord = #fontString.wordWidths
			local lastWordOnSecondToLastLine = lastWord - wordsOnLastLine

			-- Get the width of the last line
			local lastLineWidth = 0
			for i = 1, fontString.wordsPerLine[numLines] do
				lastLineWidth = lastLineWidth + fontString.wordWidths[lastWordOnSecondToLastLine + i]
			end

			-- Get the width of the second to last line
			local secondToLastLineWidth = 0
			local lastWordOnThirdLastLine = lastWordOnSecondToLastLine - wordsOnSecondToLastLine
			for i = 1, fontString.wordsPerLine[numLines - 1] do
				secondToLastLineWidth = secondToLastLineWidth + fontString.wordWidths[lastWordOnThirdLastLine + i]
			end

			-- Split the words on the 2 last lines, but keep the second to last larger
			for i = lastWord - 1, 1, -1 do
				local currentWordWidth = fontString.wordWidths[i]
				if ((lastLineWidth + currentWordWidth) < minWidth) and ((secondToLastLineWidth - currentWordWidth) > (lastLineWidth + currentWordWidth)) then
					fontString.wordsPerLine[numLines] = fontString.wordsPerLine[numLines] + 1
					fontString.wordsPerLine[numLines - 1] = fontString.wordsPerLine[numLines - 1] - 1

					secondToLastLineWidth = secondToLastLineWidth - currentWordWidth
					lastLineWidth = lastLineWidth + currentWordWidth
				else
					break
				end
			end
		end

		-- Format the string with our own line breaks
		newMsg = ""
		local currentWord = 1
		for currentLine, numWords in ipairs(fontString.wordsPerLine) do
			for i = 1, numWords do
				newMsg = newMsg .. fontString.words[currentWord]
				if (i == numWords) then
					if (currentLine < numLines) then
						newMsg = newMsg .. "\n" -- add a line break
					end
				else
					newMsg = newMsg .. " " -- add a space between the words
				end
				currentWord = currentWord + 1
			end
		end
		newHeight = minHeight*numLines + (numLines-1)*lineSpacing
	end

	-- Set our new sizes
	fontString:SetHeight(newHeight or minHeight) 
	fontString:SetText(newMsg or msg)

	-- Show the fontstring again
	fontString:Show() 

	-- Return the sizes
	return newHeight or minHeight
end

-- Create a square/dot used for unfinished objectives (and the completion texts)
local createDot = function(parent)
	local backdrop = getPixelPerfectBackdrop()
	local dot = parent:CreateFrame("Frame")
	dot:SetSize(10, 10)
	dot:SetBackdrop(backdrop)
	dot:SetBackdropColor(0, 0, 0, .75)
	dot:SetBackdropBorderColor( 240/255, 240/255, 240/255, .85)

	backdropCache[dot] = backdrop

	return dot
end

-- Sort function for our tracker display
-- 	world quests > normal quests
-- 	world quest proximity > level > name

local sortByLevelAndName = function(a,b)
	if (not a) or (not b) then
		return 
	end

	if a.questLevel and b.questLevel and (a.questLevel ~= b.questLevel) then
		return a.questLevel < b.questLevel
	elseif a.questTitle and b.questTitle then
		return a.questTitle < b.questTitle
	end
end

local sortByProximity = function(a,b)
	if (not a) or (not b) then
		return 
	end

	-- Get current player coordinates
	local posX, posY = GetPlayerMapPosition("player")

	-- Store them for later if they exist
	if (posX and posY) and (posX > 0) and (posY > 0) then
		CURRENT_PLAYER_X, CURRENT_PLAYER_Y = posX, posY
	else 
		posX, posY = CURRENT_PLAYER_X, CURRENT_PLAYER_Y
	end

	-- Figure out which is closest, if we have current or stored player coordinates available
	if (posX and posY) and (a.x and a.y and b.x and b.y) then
		return math_sqrt( math_abs(a.x - posX)^2 + math_abs(a.y - posY)^2 ) < math_sqrt( math_abs(b.x - posX)^2 + math_abs(b.y - posY)^2 )
	else
		return sortByLevelAndName(a,b)
	end
end

local sortFunction = function(a,b)

	if a.isComplete and b.isComplete then
		return sortByLevelAndName(a,b)
	elseif a.isComplete then
		return false
	elseif a.isElite and b.isElite then
		return sortByLevelAndName(a,b)
	elseif a.isElite then
		return false
	elseif a.isWorldQuest and b.isWorldQuest then
		if a.isElite or b.isElite then
			return not a.isElite
		else
			return sortByProximity(a,b)
		end
	elseif a.isWorldQuest then
		return true
	else
		return sortByLevelAndName(a,b)
	end

end



-- Maximize/Minimize button Template
-----------------------------------------------------
local MinMaxButton = Engine:CreateFrame("Button")
MinMaxButton_MT = { __index = MinMaxButton }

MinMaxButton.OnClick = function(self, mouseButton)
	if self:IsEnabled() then
		if (self.currentState == "maximized") then
			self.body:Hide()
			self.currentState = "minimized"
			PlaySound("igQuestListClose")
		else
			self.body:Show()
			self.currentState = "maximized"
			PlaySound("igQuestListOpen")
		end
	end	
	self:UpdateLayers()
end

MinMaxButton.UpdateLayers = function(self)
	if self:IsEnabled() then
		--if (self:GetAttribute("currentState") == "maximized") then
		if (self.currentState == "maximized") then
			if self:IsMouseOver() then
				self.minimizeTexture:SetAlpha(0)
				self.minimizeHighlightTexture:SetAlpha(1)
				self.maximizeTexture:SetAlpha(0)
				self.maximizeHighlightTexture:SetAlpha(0)
				self.disabledTexture:SetAlpha(0)
			else
				self.minimizeTexture:SetAlpha(1)
				self.minimizeHighlightTexture:SetAlpha(0)
				self.maximizeTexture:SetAlpha(0)
				self.maximizeHighlightTexture:SetAlpha(0)
				self.disabledTexture:SetAlpha(0)
			end
		else
			if self:IsMouseOver() then
				self.minimizeTexture:SetAlpha(0)
				self.minimizeHighlightTexture:SetAlpha(0)
				self.maximizeTexture:SetAlpha(0)
				self.maximizeHighlightTexture:SetAlpha(1)
				self.disabledTexture:SetAlpha(0)
			else
				self.minimizeTexture:SetAlpha(0)
				self.minimizeHighlightTexture:SetAlpha(0)
				self.maximizeTexture:SetAlpha(1)
				self.maximizeHighlightTexture:SetAlpha(0)
				self.disabledTexture:SetAlpha(0)
			end
		end
	else
		self.minimizeTexture:SetAlpha(0)
		self.minimizeHighlightTexture:SetAlpha(0)
		self.maximizeTexture:SetAlpha(0)
		self.maximizeHighlightTexture:SetAlpha(0)
		self.disabledTexture:SetAlpha(1)
	end
end



-- Item Template
-----------------------------------------------------
local Item = Engine:CreateFrame("Button")
Item_MT = { __index = Item }


-- Entry Title (clickable button)
-----------------------------------------------------
local Title = Engine:CreateFrame("Button")
Title_MT = { __index = Title }

Title.OnClick = function(self, mouseButton)
	local questLogIndex = self._owner.questLogIndex

	-- This is needed to open to the correct index in Legion
	-- *Might be needed in other versions too, not sure. 
	--  Function got added in Cata, so that's where we start too.
	if ENGINE_CATA then
		questLogIndex = GetQuestLogIndexByID(self._owner.questID)
	end

	if IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow() then
		local questLink = GetQuestLink(questLogIndex)
		if questLink then
			ChatEdit_InsertLink(questLink)
		end
	elseif not(mouseButton == "RightButton") then
		CloseDropDownMenus()
		if ENGINE_WOD then
			QuestLogPopupDetailFrame_Show(questLogIndex)
		else
			QuestLog_OpenToQuest(questLogIndex)
		end
	end
end


-- Entry Template (tracked quests, achievements, etc)
-----------------------------------------------------
local Entry = Engine:CreateFrame("Frame")
Entry_MT = { __index = Entry }

-- Creates a new objective element
Entry.AddObjective = function(self, objectiveType)
	local objectives = self.objectives

	local width = math_floor(self:GetWidth() + .5)

	local objective = self:CreateFrame("Frame")
	objective:SetSize(width, .0001)

	-- Objective text
	local msg = objective:CreateFontString()
	msg:SetHeight(objectives.standardHeight)
	msg:SetWidth(width)
	msg:Place("TOPLEFT", objective, "TOPLEFT", objectives.leftMargin, 0)
	msg:SetDrawLayer("BACKGROUND")
	msg:SetJustifyH("LEFT")
	msg:SetJustifyV("TOP")
	msg:SetIndentedWordWrap(false)
	msg:SetWordWrap(true)
	msg:SetNonSpaceWrap(false)
	msg:SetFontObject(objectives.normalFont)
	msg:SetSpacing(objectives.lineSpacing)

	-- Unfinished objective dot
	local dot = createDot(objective)
	dot:Place("TOP", msg, "TOPLEFT", -math_floor(objectives.leftMargin/2), objectives.dotAdjust)

	objective.msg = msg
	objective.dot = dot

	return objective
end

local UIHider = CreateFrame("Frame")
UIHider:Hide()

-- Creates a new quest item element
Entry.AddQuestItem = function(self)
	local config = self.config
	local num = #itemButtons + 1
	local name = "Engine_QuestItemButton"..num

	local item = setmetatable(self:CreateFrame("Button", name, ENGINE_WOD and "QuestObjectiveItemButtonTemplate" or "WatchFrameItemButtonTemplate"), Item_MT)
	item:Hide()

	-- We just clean out everything from the old template, 
	-- as we're really only after its inherited functionality.
	-- The looks and elements will be manually created by us instead.
	if ENGINE_WOD then
		for i,key in ipairs({ "Cooldown", "Count", "icon", "HotKey", "NormalTexture" }) do
			local exists = item[key]
			if exists then
				exists:SetParent(UIHider)
				exists:Hide()
			end
		end
	else
		for i,key in ipairs({ "Cooldown", "Count", "HotKey", "IconTexture", "NormalTexture", "Stock" }) do
			local exists = _G[name..key]
			if exists then
				exists:SetParent(UIHider)
				exists:Hide()
			end
		end
	end

	item:SetScript("OnUpdate", nil)
	item:SetScript("OnEvent", nil)
	item:UnregisterAllEvents()
	item:SetPushedTexture("")
	item:SetHighlightTexture("")

	item:SetSize(config.body.entry.item.size[1], config.body.entry.item.size[2])
	item:SetFrameLevel(self:GetFrameLevel() + 10) -- gotta get it above the title button

	local glow = item:CreateFrame("Frame")
	glow:SetFrameLevel(item:GetFrameLevel())
	glow:SetPoint("CENTER", 0, 0)
	glow:SetSize(config.body.entry.item.glow.size[1], config.body.entry.item.glow.size[2])
	glow:SetBackdrop(config.body.entry.item.glow.backdrop)
	glow:SetBackdropColor(0, 0, 0, 0)
	glow:SetBackdropBorderColor(0, 0, 0, 1)

	local scaffold = item:CreateFrame("Frame")
	scaffold:SetFrameLevel(item:GetFrameLevel() + 1)
	scaffold:SetPoint("CENTER", 0, 0)
	scaffold:SetSize(config.body.entry.item.border.size[1], config.body.entry.item.border.size[2])
	scaffold:SetBackdrop(getPixelPerfectBackdrop())
	scaffold:SetBackdropColor(0, 0, 0, 1)
	scaffold:SetBackdropBorderColor(C.General.UIBorder[1], C.General.UIBorder[2], C.General.UIBorder[3], 1)

	local newIconTexture = scaffold:CreateTexture()
	newIconTexture:SetDrawLayer("BORDER")
	newIconTexture:SetPoint("CENTER", 0, 0)
	newIconTexture:SetSize(config.body.entry.item.icon.size[1], config.body.entry.item.icon.size[2])

	local newCooldown = item:CreateFrame("Cooldown")
	newCooldown:SetFrameLevel(item:GetFrameLevel() + 2)
	newCooldown:Hide()
	newCooldown:SetAllPoints(newIconTexture)

	if ENGINE_WOD then
		newCooldown:SetSwipeColor(0, 0, 0, .75)
		newCooldown:SetBlingTexture(TEXTURE.BLING, .3, .6, 1, .75) -- what wow uses, only with slightly lower alpha
		newCooldown:SetEdgeTexture(TEXTURE.EDGE_NORMAL)
		newCooldown:SetDrawSwipe(true)
		newCooldown:SetDrawBling(true)
		newCooldown:SetDrawEdge(false)
		newCooldown:SetHideCountdownNumbers(true) -- todo: add better numbering
	end

	local overlay = item:CreateFrame("Frame")
	overlay:SetFrameLevel(item:GetFrameLevel() + 3)
	overlay:SetAllPoints(scaffold)

	local newIconDarken = overlay:CreateTexture()
	newIconDarken:SetDrawLayer("ARTWORK")
	newIconDarken:SetAllPoints(newIconTexture)
	newIconDarken:SetColorTexture(0, 0, 0, .15)

	local newIconShade = overlay:CreateTexture()
	newIconShade:SetDrawLayer("OVERLAY")
	newIconShade:SetAllPoints(newIconTexture)
	newIconShade:SetTexture(config.body.entry.item.shade)
	newIconShade:SetVertexColor(0, 0, 0, 1)

	item.SetItemCooldown = ENGINE_WOD and function(self, start, duration, enable)
		newCooldown:SetSwipeColor(0, 0, 0, .75)
		newCooldown:SetDrawEdge(false)
		newCooldown:SetDrawBling(false)
		newCooldown:SetDrawSwipe(true)

		if duration > .5 then
			newCooldown:SetCooldown(start, duration)
			newCooldown:Show()
		else
			newCooldown:Hide()
		end

	end or function(self, start, duration, enable)
		-- Try to prevent the strange WotLK bug where the end shine effect
		-- constantly pops up for a random period of time. 
		if duration > .5 then
			newCooldown:SetCooldown(start, duration)
			newCooldown:Show()
		else
			newCooldown:Hide()
		end
	end
	
	item.SetItemTexture = function(self, ...)
		newIconTexture:SetTexture(...)
	end

	itemButtons[num] = item

	item:Show()

	return item
end

-- Updates an objective, and adds new ones as needed
Entry.SetObjective = function(self, objectiveID)
	local objectives = self.objectives
	local objective = objectives[objectiveID] or self:AddObjective()
	local currentQuestData = questData[self.questID] 
	local currentQuestObjectives = currentQuestData.questObjectives[objectiveID]

	-- We're not currently using progress bars, 
	-- so objectives that are bars are displayed as a percentage only. 
	-- Also note that item count and percentages are displayed in forced green after the text, 
	-- and hidden from view when their value is at 0 and the player hasn't started progressing yet.
	local description
	if currentQuestObjectives.item then
		local current = tonumber(currentQuestObjectives.numCurrent) or 0
		if (current == 0) then
			description = currentQuestObjectives.item
		else
			if currentQuestObjectives.objectiveType == "progressbar" then
				description = currentQuestObjectives.item .. " |cff66aa22" .. currentQuestObjectives.numCurrent .. "%|r"
			else
				description = currentQuestObjectives.item .. " |cff66aa22" .. currentQuestObjectives.numCurrent .. "/" .. currentQuestObjectives.numNeeded .. "|r"
			end
		end
	else
		description = currentQuestObjectives.description
	end

	objective:SetHeight(setTextAndGetSize(objective.msg, description, objectives.standardWidth, objectives.standardHeight))
	objective:Show()

	-- Update the pointer in case it's a new objective, 
	-- or the order got changed(?) (gotta revisit this)
	objectives[objectiveID] = objective

	return objective
end

-- Clears an objective
Entry.ClearObjective = function(self, objectiveID)
	local objective = self.objectives[objectiveID]
	if (not objective) then
		return
	end
	objective.msg:SetText("")
	objective:ClearAllPoints()
	objective:Hide()
end

-- Clears all displayed objectives
Entry.ClearObjectives = function(self)
	local objectives = self.objectives
	for objectiveID = #objectives,1,-1 do
		self:ClearObjective(objectiveID)
	end
end

-- Sets the questID of the current tracker entry
Entry.SetQuest = function(self, questLogIndex, questID)
	local entryHeight = 0.0001

	-- Set the IDs of this entry, and thus tell the tracker it's in use
	self.questID = questID
	self.questLogIndex = questLogIndex

	-- Grab the data about the current quest
	local currentQuestData = questData[questID]

	-- Shortcuts to our own elements
	local title = self.title
	local titleText = self.title.msg
	local body = self.body
	local completionText = self.completionText

	-- Set and size the title
	-- We add a blue or purple plus sign for elite world quests, 
	-- to indicate their difficulty in a non-intrusive manner.
	local titleMessage 
	if currentQuestData.isElite and currentQuestData.rarity then
		titleMessage = currentQuestData.questTitle .. " " .. C.Quality[currentQuestData.rarity].colorCode .. "+" .. "|r"
	else
		titleMessage = currentQuestData.questTitle
	end
	local titleHeight = setTextAndGetSize(titleText, titleMessage, title:GetWidth(), title.standardHeight)
	title:SetHeight(titleHeight) 

	entryHeight = entryHeight + titleHeight

	-- Tone down completed entries
	self:SetAlpha(currentQuestData.isComplete and .5 or 1)

	-- Update objective descriptions and completion text
	if currentQuestData.isComplete then
		if (not currentQuestData.hasBeenCompleted) then
			-- Clear away all objectives
			self:ClearObjectives()

			-- No need repeating this step
			currentQuestData.hasBeenCompleted = true
		end

		-- Change quest description to the completion text
		local completeMsg = (currentQuestData.completionText and currentQuestData.completionText ~= "") and currentQuestData.completionText or BLIZZ_LOCALE.QUEST_COMPLETE
		local height = setTextAndGetSize(completionText, completeMsg, completionText.standardWidth, completionText.standardHeight)
		completionText:SetHeight(height)
		completionText.dot:Show()

		entryHeight = entryHeight + completionText.topOffset + height + completionText.bottomMargin

	else
		-- Just make sure the completion text is hidden
		completionText:SetText("")
		completionText:SetSize(completionText.standardWidth, completionText.standardHeight)
		completionText.dot:Hide()

		-- Update the current or remaining quest objectives
		local objectives = self.objectives
		local objectiveOffset = objectives.topOffset
		local currentQuestObjectives = currentQuestData.questObjectives

		local visibleObjectives = 0
		local numObjectives = #currentQuestObjectives

		if numObjectives > 0 then
			for objectiveID = 1, numObjectives  do
				-- Only display unfinished quest objectives
				if (currentQuestObjectives[objectiveID].isCompleted) then
					self:ClearObjective(objectiveID)
				else
					visibleObjectives = visibleObjectives + 1

					local objective = self:SetObjective(objectiveID)
					local height = objective:GetHeight()

					if visibleObjectives > 1 then
						objectiveOffset = objectiveOffset + objectives.topMargin
						entryHeight = entryHeight + objectives.topMargin
					end

					-- Since the order and visibility of the objectives 
					-- change based on the visible ones, we need to reset
					-- all the points here, or the objective will "disappear".
					objective:Place("TOPLEFT", self.title, "BOTTOMLEFT", 0, -objectiveOffset)

					objectiveOffset = objectiveOffset + height
					entryHeight = entryHeight + height
				end
			end
			
			-- Only add the bottom padding if there 
			-- actually was any unfinished objectives to show. 
			if visibleObjectives > 0 then
				entryHeight = entryHeight + objectives.bottomMargin
			end
		end

		-- A lot of quests in especially in the Cata (and higher) starting zones are 
		-- of the "go to some NPC"-type, has no objectives, and are finished the instant they start.
		-- For some reason though they still get counted as not finished in my tracker,
		-- so we simply squeeze in a slightly more descriptive text here. 
		if visibleObjectives == 0 then

			-- Change quest description to the completion text
			local completeMsg = (currentQuestData.completionText and currentQuestData.completionText ~= "") and currentQuestData.completionText or BLIZZ_LOCALE.QUEST_COMPLETE
			local height = setTextAndGetSize(completionText, completeMsg, completionText.standardWidth, completionText.standardHeight)
			completionText:SetHeight(height)
			completionText.dot:Show()

			entryHeight = entryHeight + completionText.topOffset + height + completionText.bottomMargin
		end

		-- Clear finished objectives (or remnants from previously tracked quests)
		for objectiveID = numObjectives + 1, #self.objectives do
			self:ClearObjective(objectiveID)
		end
	end

	if (currentQuestData.isWorldQuest) then
		title:SetScript("OnClick", nil)
	else
		title:SetScript("OnClick", Title.OnClick)
	end

	self:SetHeight(entryHeight)

end

-- Sets which quest item to display along with the quest entry
-- *Todo: add support for equipped items too! 
Entry.SetQuestItem = function(self)
	local item = self.questItem or self:AddQuestItem()
	item:SetID(self.questLogIndex)
	item:Place("TOPRIGHT", -10, -4)
	item:SetItemTexture(questData[self.questID].icon)
	item:Show()

	self.questItem = item
	activeItemButtons[item] = self

	return questItem
end

Entry.UpdateQuestItem = function(self)
end

-- Removes any item currently connected with the entry's current quest.
Entry.ClearQuestItem = function(self)
	local item = self.questItem
	if item then
		item:Hide()
		activeItemButtons[item] = nil
	end
end

-- Returns the questID of the entry's current quest, or nil if none.
Entry.GetQuestID = function(self)
	return self.questID
end

-- Clear the entry
Entry.Clear = function(self)
	self.questID = nil
	self.questLogIndex = nil

	-- Clear the messages 
	self.title.msg:SetText("")
	self.completionText:SetText("")

	-- Clear the quest item, if any
	self:ClearQuestItem()

	-- Clear away all objectives
	self:ClearObjectives()	
end



-- Tracker Template
-----------------------------------------------------
local Tracker = Engine:CreateFrame("Frame")
Tracker_MT = { __index = Tracker }

Tracker.AddEntry = function(self)
	local config = self.config

	local width = math_floor(self:GetWidth() + .5) 

	local entry = setmetatable(self.body:CreateFrame("Frame"), Entry_MT)
	entry:Hide()
	entry:SetHeight(0.0001)
	entry:SetWidth(width)
	entry.config = config
	entry.topMargin = config.body.entry.topMargin
	
	-- Title region
	-----------------------------------------------------------
	local title = setmetatable(entry:CreateFrame("Button"), Title_MT)
	title:Place("TOPLEFT", 0, 0)
	title:SetWidth(width)
	title:SetHeight(config.body.entry.title.height)
	title.standardHeight = config.body.entry.title.height
	title.maxLines = config.body.entry.title.maxLines -- not currently used
	title.leftMargin = config.body.entry.title.leftMargin
	title.rightMargin = config.body.entry.title.rightMargin

	title._owner = entry
	title:EnableMouse(true)
	title:SetHitRectInsets(-10, -10, -10, -10)
	title:RegisterForClicks("LeftButtonUp")
	--title:SetScript("OnClick", Title.OnClick)

	-- Quest title
	local titleText = title:CreateFontString()
	titleText:SetHeight(title.standardHeight)
	titleText:SetWidth(width)
	titleText:Place("TOPLEFT", 0, 0)
	titleText:SetDrawLayer("BACKGROUND")
	titleText:SetJustifyH("LEFT")
	titleText:SetJustifyV("TOP")
	titleText:SetIndentedWordWrap(false)
	titleText:SetWordWrap(true)
	titleText:SetNonSpaceWrap(false)
	titleText:SetFontObject(config.body.entry.title.normalFont)
	titleText:SetSpacing(config.body.entry.title.lineSpacing)

	title.msg = titleText

	-- Flash messages like "NEW", "UPDATE", "COMPLETED" and so on
	local flashMessage = title:CreateFontString()
	flashMessage:SetDrawLayer("BACKGROUND")
	flashMessage:SetPoint("RIGHT", title, "LEFT", 0, -10)



	-- Body region
	-----------------------------------------------------------
	local body = entry:CreateFrame("Frame")
	body:SetWidth(width)
	body:SetHeight(.0001)
	body:Place("TOPLEFT", title, "BOTTOMLEFT", config.body.margins.left, config.body.margins.top)

	-- Quest complete text
	local completionText = body:CreateFontString()
	completionText.topOffset = config.body.entry.complete.topOffset
	completionText.leftMargin = config.body.entry.complete.leftMargin
	completionText.rightMargin = config.body.entry.complete.rightMargin
	completionText.topMargin = config.body.entry.complete.topMargin
	completionText.bottomMargin = config.body.entry.complete.bottomMargin
	completionText.lineSpacing = config.body.entry.complete.lineSpacing
	completionText.standardHeight = config.body.entry.complete.height
	completionText.standardWidth = width - completionText.leftMargin - completionText.rightMargin
	completionText.maxLines = config.body.entry.complete.maxLines -- not currently used
	completionText.dotAdjust = config.body.entry.complete.dotAdjust

	completionText:SetFontObject(config.body.entry.complete.normalFont)
	completionText:SetSpacing(completionText.lineSpacing)
	completionText:SetWidth(width)
	completionText:SetHeight(completionText.standardHeight)

	completionText:Place("TOPLEFT", title, "BOTTOMLEFT", completionText.leftMargin, -completionText.topOffset)
	completionText:SetDrawLayer("BACKGROUND")
	completionText:SetJustifyH("LEFT")
	completionText:SetJustifyV("TOP")
	completionText:SetIndentedWordWrap(false)
	completionText:SetWordWrap(true)
	completionText:SetNonSpaceWrap(false)

	completionText.dot = createDot(body)
	completionText.dot:Place("TOP", completionText, "TOPLEFT", -math_floor(completionText.leftMargin/2), completionText.dotAdjust)
	completionText.dot:Hide()

	-- Cache of the current quest objectives
	local objectives = {
		standardHeight = config.body.entry.objective.height,
		standardWidth = width - config.body.entry.objective.leftMargin - config.body.entry.objective.rightMargin,
		topOffset = config.body.entry.objective.topOffset,
		leftMargin = config.body.entry.objective.leftMargin,
		rightMargin = config.body.entry.objective.rightMargin,
		topMargin = config.body.entry.objective.topMargin,
		bottomMargin = config.body.entry.objective.bottomMargin,
		lineSpacing = config.body.entry.objective.lineSpacing,
		normalFont = config.body.entry.objective.normalFont,
		dotAdjust = config.body.entry.objective.dotAdjust
	} 

	entry.body = body
	entry.completionText = completionText
	entry.flash = flashMessage
	entry.objectives = objectives
	entry.title = title

	-- test
	--local tex = entry:CreateTexture()
	--tex:SetColorTexture(0, 0, 0, .5)
	--tex:SetAllPoints()	

	return entry
end

-- Full tracker update.
Tracker.Update = function(self)
	local entries = self.entries
	local numEntries = #entries

	local maxTrackerHeight = self:GetHeight()
	local currentTrackerHeight = self.header:GetHeight() + 4

	for i = 1, numEntries do
		local entry = entries[i]
		entry:Hide()
		entry:Clear()
		entry:ClearAllPoints() 
	end

	-- Clear everything and return if nothing is tracked in the zone
	local numZoneQuests = #sortedTrackedQuests
	if (numZoneQuests == 0) then
		return
	end 

	--[[


	-- Do a sweep to remove untracked questIDs
	for questID, entryID in pairs(trackedQuestsByQuestID) do
		local entryID
		for i = 1, numZoneQuests do
			local zoneQuest = sortedTrackedQuests[i]
			if zoneQuest.questID == questID then
				entryID = i
				break
			end
		end
		-- As the questID is no longer tracked, 
		-- we clear it from our database.
		-- 
		-- Update 2017-07-06:
		-- Either this isn't working, or this isn't called properly or at the correct time, 
		-- because completed world quests remain in the log, though become unresponsive 
		-- and refuses to be removed no matter how many times I change the zone. 
		-- Only a /reload will remove it, which is clearly NOT the intended behavior! 
		-- 
		if (not entryID) or (questData[questID] and questData[questID].isComplete) then
			trackedQuestsByQuestID[questID] = nil
		end
	end
	]]

	-- Do a first pass to find already tracked quests, 
	-- and reorder database as needed.
	-- ...something feels a bit wonky here...
	for i = 1, numZoneQuests do
		local zoneQuest = sortedTrackedQuests[i]
		local oldID = trackedQuestsByQuestID[zoneQuest.questID]
		if oldID then
			-- Grab the existing entry, if any
			local currentEntry = entries[i]

			-- Grab the existing entryID of the quest
			local oldEntry = entries[oldID]

			-- Put the entry in the current place
			entries[i] = oldEntry

			-- Put the current entry where the old one was?
			entries[oldID] = currentEntry

			-- Update the pointer of tracked questIDs 
			-- to reflect the new entryID
			trackedQuestsByQuestID[zoneQuest.questID] = i
		end
	end

	if (#sortedTrackedQuests > 0) then
		-- Supertrack if we have a valid quest
		local zoneQuest = sortedTrackedQuests[1]
		if zoneQuest.questID then
			SetSuperTrackedQuestID(zoneQuest.questID)
		else
			SetSuperTrackedQuestID(0)
		end
	else
		SetSuperTrackedQuestID(0)
	end

	-- Update existing and create new entries
	local anchor = self.header
	local offset = 0
	for i = 1, numZoneQuests do

		-- Get the zone quest data
		local zoneQuest = sortedTrackedQuests[i]

		-- Sometimes the events collide or something, 
		-- and we end up calling this right after the questData
		-- has been deleted, thus resulting in a nil error up 
		-- in the SetQuest() method. 
		-- Trying to avoid this now.
		if questData[zoneQuest.questID] then
			local currentQuestData = questData[zoneQuest.questID]

			-- Get the entry or create one
			local entry = entries[i] or self:AddEntry()

			-- Set the entry's quest
			entry:SetQuest(zoneQuest.questLogIndex, zoneQuest.questID)

			-- Store the current entryID of the quest 
			trackedQuestsByQuestID[zoneQuest.questID] = i
			
			-- Set the entry's usable item, if any
			if currentQuestData.hasQuestItem and ((not currentQuestData.isComplete) or currentQuestData.showItemWhenComplete) then
				entry:SetQuestItem()
			else
				entry:ClearQuestItem()
			end

			-- Update entry pointer
			entries[i] = entry

			-- Don't show more entries than there's room for,
			-- forcefully quit and hide the rest when it would overflow.
			-- Will add a better system later.
			local entrySize = entry.topMargin + entry:GetHeight()
			if ((currentTrackerHeight + entrySize) > maxTrackerHeight) then
				numZoneQuests = i-1
				break
			else
				-- Add the top margin to the offset
				offset = offset + entry.topMargin

				-- Position the entry
				entry:Place("TOPLEFT", anchor, "BOTTOMLEFT", 0, -offset)
				entry:Show()

				-- Add the entry's size to the offset
				offset = offset + entry:GetHeight()

				-- Add the full size of the entry with its margin to the tracker height 
				currentTrackerHeight = currentTrackerHeight + entrySize
			end
		else
			-- hide finished entries
			local entry = entries[i]
			if entry then
				entry:Hide()
				entry:Clear()
				entry:ClearAllPoints() 
			end
		end
	end

	-- Hide unused entries
	for i = numZoneQuests + 1, numEntries do
		local entry = entries[i]
		if entry then
			entry:Hide()
			entry:Clear()
			entry:ClearAllPoints() 
		end
	end	

end

Module.UpdateItemCooldowns = function(self)
	for item,entry in pairs(activeItemButtons) do
		local start, duration, enable = GetQuestLogSpecialItemCooldown(item:GetID())
		if (start and duration) then
			item:SetItemCooldown(start, duration, enable)
		else
			item:SetItemCooldown(0, 0, false)
		end
	end
end

local allQuestTimers = {}
local activeQuestTimers = {}
local finishedQuestTimers = {}

Module.ParseTimers = function(self, ...)
	local numTimers = select("#", ...)
	for timerId = 1, numTimers do
		local questLogIndex = GetQuestIndexForTimer(timerId)

		local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID
		if ENGINE_WOD then
			questTitle, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle(questLogIndex)
		else
			questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(questLogIndex)
		end

		local timeFirst = select(timerId, ...)
		activeQuestTimers[questID] = timeFirst

	end
end


-- Should only be done out of combat. 
-- To have more control we user our own combat tracking system here, 
-- instead of relying on the Engine's secure wrapper handler.  
-- 
-- Note that we can theoretically experience situations where
-- the tracker is hidden before combat, a quest is accepted during combat, 
-- and the tracker isn't displayed until combat ends. 
-- This is acceptable, though, as we strictly speaking aren't constantly 
-- in combat, and if there is a BIG fight going on, it is ok to wait. 
--
-- Update 2017-07-05:
-- The tracker isn't a secure frame... only its parent is. Doh.
Module.UpdateTrackerVisibility = function(self, numZoneQuests)
	local isInInstance, instanceType = IsInInstance()
	if isInInstance and (instanceType == "pvp" or instanceType == "arena") then
		return self.tracker:Hide()
	end
	if ((numZoneQuests and (numZoneQuests > 0)) or (#sortedTrackedQuests > 0)) then
		return self.tracker:Show()
	else
		return self.tracker:Hide()
	end
end

-- Fairly big copout here, and we need to expand 
-- on it later to avoid overriding user choices. 
-- Based on self:QuestSuperTracking_ChooseClosestQuest()
Module.UpdateSuperTracking = function(self)
	local closestQuestID
	local minDistSqr = math_huge

	-- World quest watches got introduced in Legion
	-- 
	-- Update 2017-07-06:
	-- This appears to be tracking "hidden" bonus objectives too, not just world quests. 
	-- This leads to the wrong objective getting its arrow on the Minimap, 
	-- pointing the player to a different objective than what the tracker shows. 
	-- 
	if ENGINE_LEGION then
		for i = 1, GetNumWorldQuestWatches() do
			local watchedWorldQuestID = GetWorldQuestWatchInfo(i)
			if watchedWorldQuestID then
				local currentQuestData = questData[watchedWorldQuestID]
				if currentQuestData and (not currentQuestData.isComplete) then
					local distanceSq = C_TaskQuest.GetDistanceSqToQuest(watchedWorldQuestID)
					if distanceSq and distanceSq <= minDistSqr then
						minDistSqr = distanceSq
						closestQuestID = watchedWorldQuestID
					end
				end
			end
		end
	end

	if ENGINE_WOD then
		if (not closestQuestID) then
			for i = 1, GetNumQuestWatches() do
				local questID, title, questLogIndex = GetQuestWatchInfo(i)
				if ( questID and QuestHasPOIInfo(questID) ) then
					local distSqr, onContinent = GetDistanceSqToQuest(questLogIndex)
					if ( onContinent and distSqr <= minDistSqr ) then
						minDistSqr = distSqr
						closestQuestID = questID
					end
				end
			end
		end
	end

	-- If nothing with POI data is being tracked expand search to quest log
	if (not closestQuestID) then
		for questLogIndex = 1, GetNumQuestLogEntries() do
			local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle(questLogIndex)
			if (not isHeader and QuestHasPOIInfo(questID)) then
				local distSqr, onContinent = GetDistanceSqToQuest(questLogIndex)
				if (onContinent and distSqr <= minDistSqr) then
					minDistSqr = distSqr
					closestQuestID = questID
				end
			end
		end
	end

	-- Supertrack if we have a valid quest
	if closestQuestID then
		SetSuperTrackedQuestID(closestQuestID)
	else
		SetSuperTrackedQuestID(0)
	end
end

Module.ParseAutoQuests = function(self)
	local needUpdate
	for i = 1, GetNumAutoQuestPopUps() do
		local questID, popUpType = GetAutoQuestPopUp(i)
		if (questId == questID) then
			if (popUpType == "OFFER") then
				ShowQuestOffer(questLogIndex)

			else
				PlaySound("UI_AutoQuestComplete")
				ShowQuestComplete(questLogIndex)
			end
			needUpdate = true
		end
	end
	return needUpdate
end

-- Just a proxy method to update the tracker(s).
-- Eventually this will include the different trackers I plan to implement, 
-- but for now it merely contains the standard quest / world quest tracker.
Module.UpdateTracker = function(self)
	self.tracker:Update()
	self:UpdateTrackerVisibility()
end

-- Workaround for some annoying Blizzard display bugs, 
-- that leaves the quest window open for completed or 
-- automatically accepted quests.
-- 
-- Update 2017-06-23-1527: 
-- The Complete Quest button and the frame remains visible,
-- for quests in Pandaria and above, so I need to figure out 
-- where exactly it fails in these expansions, and why. 
--
-- Update 2017-06-24-1236:
-- The isComplete argument is actually isFinished, but doesn't 
-- really say whether or not the quest has been completed yet. 
-- This leads to the questframe being auto-closed by this script
-- before we actually get the chance to turn in the quest... /doh. 
-- We need to somehow hook this to the click functionality of the button, 
-- do this before the button is shown in the first place, 
-- and further make sure that the script remains on the button later on.
-- WOOOOOORK!
Module.UpdateQuestFrameVisibility = function(self, icComplete)
	if isComplete then
		--if (QuestFrameCompleteButton:GetText() == BLIZZ_LOCALE.COMPLETE) then
		--	QuestFrame:Hide()
		--end
	else
		-- (QuestFrameCompleteQuestButton:GetText() == BLIZZ_LOCALE.COMPLETE_QUEST)
		--if (QuestFrameAcceptButton:GetText() == BLIZZ_LOCALE.ACCEPT) then
		--	QuestFrame:Hide()
		--end
	end
end

-- All the isSomething entries will return strict true/false values here
-- @return questID, questTitle, questLevel, suggestedGroup, isHeader, isComplete, isFailed, isRepeatable
Module.GetQuestLogTitle = ENGINE_WOD and function(self, questLogIndex)
	local questTitle, questLevel, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle(questLogIndex)
	return questID, questTitle, questLevel, suggestedGroup, isHeader, (isComplete == 1), (isComplete == -1), (frequency > 1)

end or function(self, questLogIndex)
	local questTitle, questLevel, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(questLogIndex)
	return questID, questTitle, questLevel, suggestedGroup, (isHeader == 1), (isComplete == 1), (isComplete == -1), (isDaily == 1)
end

Module.GetQuestLogLeaderBoard = function(self, objectiveIndex, questLogIndex)
	local description, objectiveType, isCompleted = GetQuestLogLeaderBoard(objectiveIndex, questLogIndex)
	local item, numCurrent, numNeeded = string_match(description, questCaptures[objectiveType]) 

	if (objectiveType == "progressbar") then
		item = description
		numCurrent = GetQuestProgressBarPercent((self:GetQuestLogTitle(questLogIndex)))
		numNeeded = 100
	end

	-- Some quests have objective type 'monster' yet are displayed using the ITEMS formatting.
	-- Thank you Zygor for figuring this one out. 
	if (objectiveType == "monster") and (not item) then
		item, numCurrent, numNeeded = string_match(description, questCaptures.item)
	end

	if tonumber(item) then
		local newItem = string_gsub(description, questCaptures.item, "")
		local newCurrent, newNeeded = item, numCurrent
		item, numCurrent, numNeeded = newItem, newCurrent, newNeeded
	end

	if item then
		if (objectiveType == "reputation") or (objectiveType == "faction") then
			-- We're keeping these as strings, as they most often are. (e.g. Friendly/Revered)
			return description, objectiveType, isCompleted, item, numCurrent, numNeeded 
		else
			return description, objectiveType, isCompleted, item, tonumber(numCurrent), tonumber(numNeeded)
		end
	else
		return description, objectiveType, isCompleted
	end

end

Module.GetQuestObjectiveInfo = function(self, questID, objectiveIndex)
	local description, objectiveType, isCompleted = GetQuestObjectiveInfo(questID, objectiveIndex, false)
	local item, numCurrent, numNeeded = string_match(description, questCaptures[objectiveType])

	if (objectiveType == "progressbar") then
		item = description
		numCurrent = GetQuestProgressBarPercent(questID)
		numNeeded = 100
	else
		if (objectiveType == "monster") and (not item) then
			item, numCurrent, numNeeded = string_match(description, questCaptures.item)
		end
	end

	if tonumber(item) then
		local newItem = string_gsub(description, questCaptures.item, "")
		local newCurrent, newNeeded = item, numCurrent
		item, numCurrent, numNeeded = newItem, newCurrent, newNeeded
	end
	
	if item then
		if (objectiveType == "reputation") or (objectiveType == "faction") then
			-- We're keeping these as strings, as they most often are. (e.g. Friendly/Revered)
			return string_gsub(description, "[.]$", ""), objectiveType, isCompleted, string_gsub(item, "[.]$", ""), numCurrent, numNeeded 
		else
			return string_gsub(description, "[.]$", ""), objectiveType, isCompleted, string_gsub(item, "[.]$", ""), tonumber(numCurrent), tonumber(numNeeded)
		end
	else
		return string_gsub(description, "[.]$", ""), objectiveType, isCompleted
	end
end

Module.GetCurrentMapAreaID = function(self)
	local questMapID, isContinent = GetCurrentMapAreaID()
	if (not ENGINE_CATA) then
		if questMapID > 0 then
			questMapID = questMapID - 1 -- WotLK bug
		end
	end
	return questMapID, isContinent
end

-- This updates both the Blizzard POI map tracking 
-- as well as what our own tracker should show.
Module.UpdateTrackerWatches = function(self)
	local needUpdate

	-- This step is crucial to make sure completed or removed quests
	-- are also removed from our own tracker(s). 
	-- This was what was causing the world quest update to fail. 
	for questID in pairs(allTrackedQuests) do
		if (not questLogCache[questID]) or (not worldQuestCache[questID]) then
			allTrackedQuests[questID] = nil
			zoneTrackedQuests[questID] = true
		end
	end

	for questID, questLogIndex in pairs(questLogCache) do
		if questWatchQueue[questID] then

			-- Tell our own systems about the tracking
			zoneTrackedQuests[questID] = true
			allTrackedQuests[questID] = true

			-- Tell the Blizzard POI system about it
			-- TODO: I should figure out some way to decide what quests to track 
			-- when the amount of quests we wish to track excede the blizzard limit.
			if (not IsQuestWatched(questLogIndex)) then
				AddQuestWatch(questLogIndex)
			end
		else
			-- Remove the Blizzard quest watch 
			if IsQuestWatched(questLogIndex) then
				RemoveQuestWatch(questLogIndex)
			end
		end
	end

	-- Clear this table out, to avoid weird bugs 
	-- with autocompleted entries and whatnot.
	table_wipe(questWatchQueue)

	if ENGINE_LEGION then
		for questID in pairs(worldQuestCache) do
			if worldQuestWatchQueue[questID] then

				-- Add our own tracking
				local currentQuestData = questData[questID]
				allTrackedQuests[questID] = 
					(currentQuestData.questMapID == (CURRENT_MAP_ZONE or CURRENT_PLAYER_ZONE)) and 
					(currentQuestData.isWorldQuest) and 
					(not currentQuestData.isComplete) and 
					--(currentQuestData.timeLeft and (currentQuestData.timeLeft > 0)) and
					(self:DoesWorldQuestPassFilters(questID)) or nil

				-- Add blizzard tracking
				if (not IsWorldQuestWatched(questID)) then
					AddWorldQuestWatch(questID)
				end
			else
				--- Remove blizzard tracking
				if IsWorldQuestWatched(questID) then
					RemoveWorldQuestWatch(questID)
				end
			end
		end

		-- Clear this table out, to avoid weird bugs 
		-- with autocompleted entries and whatnot.
		table_wipe(worldQuestWatchQueue)
	end

	-- Supertracking!
	-- Our own current version just supertracks whatever is closest,
	-- but we will improve this in the future to allow better control.
	--
	-- *The supertracking is actually unrelated to the tracker currently, 
	-- but since we block the blizzard code for this, we need to add something back.
	if ENGINE_CATA then
		self:UpdateSuperTracking()
	end

	return needUpdate
end

-- Update what entries the tracker should show.
-- This should eventually choose user tracked objectives first, 
-- then add in world quests, and then normal quests.
-- For now though it's not possible to manually track anything,
-- so it pretty much just iterates through already created lists, 
-- as does the actual tracker update method, though that is limited by size.
Module.UpdateTrackerEntries = function(self)
	-- Wipe the table, it's only a bunch of references anyway
	table_wipe(sortedTrackedQuests)

	-- Insert all the tracked quests
	for questID in pairs(allTrackedQuests) do
		sortedTrackedQuests[#sortedTrackedQuests + 1] = questData[questID]
	end

	-- Sort it to something more readable
	table_sort(sortedTrackedQuests, sortFunction)

	-- Update the tracker display
	self:UpdateTracker()
end

-- This will forcefully set the map zone to the current, 
-- to retrieve zone information about existing quest log entries.
-- This should only be called upon entering the world, or changing zones,
-- or we run the risk of "locking" the world map to the current zone.
Module.UpdateQuestZoneData = function(self)
	local questData = questData
	
	-- Enforcing this, regardless of whether or not the 
	-- world map is currently visible. 
	-- This is only called when changing zones or entering the world, 
	-- so it's a compromise we can live with. It doesn't affect gameplay much,
	-- and the blizzard map and tracker actually does the same. 
	SetMapToCurrentZone()

	-- Update the current player zone
	local questMapID = self:GetCurrentMapAreaID()

	-- Update what zone the player is actually in
	CURRENT_PLAYER_ZONE = questMapID 

	-- Parse the quest cache for quests with missing zone data, 
	-- which at the first time this is called should be all of them.
	-- Note that the API call GetQuestWorldMapAreaID also calls SetMapToCurrentZone,
	-- thus also forcing the map to the current zone. 
	for questID, data in pairs(questData) do
		if (not data.questMapID) then
			data.questMapID = GetQuestWorldMapAreaID(questID)
		end
	end
end

-- Figure out what quests to display for the current zone. 
-- The "current" zone is the zone the worldmap is set to if open, 
-- or the actual zone the player is in if the worldmap is closed. 
Module.UpdateZoneTracking = function(self)
	local needUpdate

	-- Update the current player zone
	local questMapID = self:GetCurrentMapAreaID()

	-- Store the current map zone
	CURRENT_MAP_ZONE = questMapID

	-- Parse the current questlog cache for quests in the active map zone
	for questID, questLogIndex in pairs(questLogCache) do

		-- Get the quest data for the current questlog entry
		local data = questData[questID]

		-- Figure out if it should be tracked or not
		local shouldBeTracked = data and (data.questMapID == (CURRENT_MAP_ZONE or CURRENT_PLAYER_ZONE)) and (not data.isWorldQuest)

		-- Add it to the questwatch update queue
		if shouldBeTracked then
			questWatchQueue[questID] = questLogIndex
			needUpdate = true -- something was changed, an update is needed
		end
	end

	-- Parse for world quests in the current zone
	if ENGINE_LEGION then
		for questID in pairs(worldQuestCache) do
			-- Get the quest data for the current world quest
			local data = questData[questID]

			-- Figure out if it should be tracked or not
			local shouldBeTracked = data and (data.questMapID == (CURRENT_MAP_ZONE or CURRENT_PLAYER_ZONE)) and (data.isWorldQuest)
			if shouldBeTracked then
				if (not worldQuestWatchQueue[questID]) then
					worldQuestWatchQueue[questID] = true
					needUpdate = true
				end
			else
				if (worldQuestWatchQueue[questID]) then
					worldQuestWatchQueue[questID] = false
					needUpdate = true
				end
			end

			-- check closest coords to current location
			
		end
	end


	-- Report back if anything was changed
	return needUpdate
end

-- Most of the below is a copy of the WorldMap_DoesWorldQuestInfoPassFilters API call from WorldMapFrame.lua
Module.DoesWorldQuestPassFilters = function(self, questID)
	local tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, displayTimeLeft = GetQuestTagInfo(questID)
	if ( worldQuestType == LE.LE_QUEST_TAG_TYPE_PROFESSION ) then
		local prof1, prof2, arch, fish, cook, firstAid = GetProfessions()
		if ((tradeskillLineIndex == prof1) or (tradeskillLineIndex == prof2)) then
			if (not GetCVarBool("primaryProfessionsFilter")) then
				return false
			end
		end
		if ((tradeskillLineIndex == fish) or (tradeskillLineIndex == cook) or (tradeskillLineIndex == firstAid)) then
			if (not GetCVarBool("secondaryProfessionsFilter")) then
				return false
			end
		end
	elseif (worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE) then
		if (not GetCVarBool("showTamers")) then
			return false
		end
	else
		local dataLoaded, rewardType = WorldMap_GetWorldQuestRewardType(questID)
		if (not dataLoaded) then
			return false
		end
		local typeMatchesFilters = (GetCVarBool("worldQuestFilterGold") and bit_band(rewardType, WQ.WORLD_QUEST_REWARD_TYPE_FLAG_GOLD) ~= 0) 
			or (GetCVarBool("worldQuestFilterOrderResources") and bit_band(rewardType, WQ.WORLD_QUEST_REWARD_TYPE_FLAG_ORDER_RESOURCES) ~= 0) 
			or (GetCVarBool("worldQuestFilterArtifactPower") and bit_band(rewardType, WQ.WORLD_QUEST_REWARD_TYPE_FLAG_ARTIFACT_POWER) ~= 0) 
			or (GetCVarBool("worldQuestFilterProfessionMaterials") and bit_band(rewardType, WQ.WORLD_QUEST_REWARD_TYPE_FLAG_MATERIALS) ~= 0) 
			or (GetCVarBool("worldQuestFilterEquipment") and bit_band(rewardType, WQ.WORLD_QUEST_REWARD_TYPE_FLAG_EQUIPMENT) ~= 0) 

		-- We always want to show quests that do not fit any of the enumerated reward types.
		if ((rewardType ~= 0) and (not typeMatchesFilters)) then
			return false
		end
	end
	return true
end

-- Parse worldquests and store the data
Module.GatherWorldQuestData = function(self)
	local needUpdate

	local oldCache = worldQuestCache
	local newCache = {}

	if isLegionZone[(self:GetCurrentMapAreaID())] then

	-- Iterate all known outdoor Legion zones
	for i = 1, #brokenIslesZones do
		local questMapID = brokenIslesZones[i]
		local worldQuests = C_TaskQuest.GetQuestsForPlayerByMapID(questMapID)

		if (worldQuests ~= nil) and (#worldQuests > 0) then
			for i,questInfo in ipairs(worldQuests) do
				local questID = questInfo.questId
				if (HaveQuestData(questID) and QuestUtils_IsQuestWorldQuest(questID) and (not (IsQuestInvasion and IsQuestInvasion(questID)))) then

					-- If this is a new quest, report that we need an update
					if (not oldCache[questID]) then
						needUpdate = true
					end

					-- Add the quest to the current cache
					newCache[questID] = true

					-- Retrieve the existing quest database, if any 
					local currentQuestData = questData[questID] or {}

					local questTitle, factionID, capped = C_TaskQuest.GetQuestInfoByQuestID(questID)
					local factionName = factionID and GetFactionInfoByID(factionID)
					local tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = GetQuestTagInfo(questID)
					local isInArea, isOnMap, numObjectives, taskName, displayAsObjective = GetTaskInfo(questID)

					local numQuestObjectives = questInfo.numObjectives or 0
					local questObjectives = currentQuestData.questObjectives or {}

					local questUpdated, questCompleted
					local numVisibleObjectives = 0
					for objectiveIndex = 1, numQuestObjectives do
						local objectiveText, objectiveType, isCompleted, item, numCurrent, numNeeded = self:GetQuestObjectiveInfo(questID, objectiveIndex)

						if isCompleted then
							if (questCompleted == nil) then
								questCompleted = true
							end
						else
							questCompleted = false
						end
						
						-- Appears to exist some empty objectives in these world quests, no idea why. 
						-- For the sake of simplicity we're doing the same as everybody else and just skip them. Or?
						if (objectiveText and #objectiveText > 0) then
							numVisibleObjectives = numVisibleObjectives + 1
							local questObjective = questObjectives[numVisibleObjectives]
							if questObjective then
								if not((objectiveText == questObjective.description) and (objectiveType == questObjective.objectiveType) and (isCompleted == questObjective.isCompleted) and (item == questObjective.item) and (numCurrent == questObjective.numCurrent) and (numNeeded == questObjective.numNeeded)) then

									-- Something was changed
									questUpdated = BLIZZ_LOCALE.UPDATE
								end

								questObjective.description = objectiveText
								questObjective.objectiveType = objectiveType
								questObjective.isCompleted = isCompleted
								questObjective.item = item
								questObjective.numCurrent = numCurrent
								questObjective.numNeeded = numNeeded

							else
								-- new quest
								questObjective = {
									description = objectiveText,
									objectiveType = objectiveType,
									isCompleted = isCompleted,
									item = item,
									numCurrent = numCurrent, 
									numNeeded = numNeeded
								}
							end
							questObjectives[numVisibleObjectives] = questObjective
						end
					end

					-- Can't really imagine why a quest's number of objectives should 
					-- change after creation, but just in case we wipe away any unneeded entries.
					-- Point is that we're using #questObjectives to determine number of objectives.
					for i = #questObjectives, numVisibleObjectives + 1, -1 do
						-- Got a nil bug here, so for some reason some of these tables don't exist...?..?
						if questObjectives[i] then
							table_wipe(questObjectives[i])
						end
					end

					-- If we're dealing with an update, figure out what kind. New quest? Failed? Completed? Updated objectives?
					currentQuestData.updateDescription = nil

					-- The data most used
					currentQuestData.questID = questID
					currentQuestData.questTitle = questTitle
					currentQuestData.questMapID = questMapID

					-- Information about the faction the quest belongs to. 
					-- Eventually I'll add this to the filtering system, 
					-- to reduce the display priority of quests 
					-- whose factions we're already maxed out with. 
					currentQuestData.factionID = factionID
					currentQuestData.factionName = factionName

					currentQuestData.numQuestObjectives = numQuestObjectives
					currentQuestData.questObjectives = questObjectives
					--currentQuestData.questDescription = questDescription -- what to use?

					-- Will be true if we're currently in the quest area and progressing on it
					currentQuestData.inProgress = questInfo.inProgress
					currentQuestData.timeLeft = C_TaskQuest.GetQuestTimeLeftMinutes(questID)

					-- World quests only show up when they're incomplete, and disappear automatically when finished, 
					-- and failed ones can be repeated instantly, they don't have to be picked up again,
					-- so both these flags is in effect always false as long as these quests exist. 
					-- 
					-- Update 2017-07-05:  
					-- The above appears to possibly be false, as far more world quests are appearing than what the map shows.
					-- Seems like the timeLeft entry is 0 (or possibly nil) for unavailable (yet available in the API) world quests.
					-- 
					-- Update 2017-07-06:
					-- The time left argument won't remove completed quests. We currently need a reload for that.
					--
					currentQuestData.isComplete = questCompleted or (not (currentQuestData.timeLeft and currentQuestData.timeLeft > 0))
					currentQuestData.isFailed = false

					currentQuestData.isWorldQuest = true -- obviously true, since we're ONLY checking for world quests here

					-- Figure out what type of world quest we're dealing with
					currentQuestData.isQuestBounty = IsQuestBounty(questID)
					currentQuestData.isQuestTask = IsQuestTask(questID)
					currentQuestData.isInvasion = worldQuestType == LE.LE_QUEST_TAG_TYPE_INVASION -- IsQuestInvasion(questID)
					currentQuestData.isDungeon = worldQuestType == LE.LE_QUEST_TAG_TYPE_DUNGEON
					currentQuestData.isRaid = worldQuestType == LE.LE_QUEST_TAG_TYPE_RAID
					currentQuestData.isPvP = worldQuestType == LE.LE_QUEST_TAG_TYPE_PVP
					currentQuestData.isPetBattle = worldQuestType == LE.LE_QUEST_TAG_TYPE_PET_BATTLE
					currentQuestData.isTradeSkill = worldQuestType == LE.LE_QUEST_TAG_TYPE_PROFESSION
					currentQuestData.isElite = isElite
					currentQuestData.rarity = rarity

					-- Store coordinates if any
					-- Will be used to figure out the closest world quest to track (maybe)
					currentQuestData.x = questInfo.x
					currentQuestData.y = questInfo.y

					-- If anything was updated within this quest, report it back
					if (currentQuestData.updateDescription) then
						needUpdate = true
					end

					-- update pointer in case it was a newly added quest
					questData[questID] = currentQuestData
				end
			end
		end

	end

	end

	-- Point the questlog cache to our new table
	worldQuestCache = newCache

	return needUpdate
end

-- Parse the questlog and store its data
-- Returns true if anything changed since last parsing
Module.GatherQuestLogData = function(self, forced)

	local playerMoney = GetMoney()
	local numEntries, numQuests = GetNumQuestLogEntries() -- quests in the quest log
	--local questFrameIsShown = QuestFrame:IsShown() -- is the quest frame visible?
	--local currentQuestID = ENGINE_CATA and questFrameIsShown and GetQuestID()

	local questData = questData
	local oldCache = questLogCache
	local newCache = {} 

	-- This is a bug that's been around since 3.3.0 
	-- when Blizzard added quests that were automatically 
	-- accepted once you simply talked to the NPC.
	-- The button text says "Accept", which is misleading
	-- since the quest already has been accepted and will
	-- stay accepted even if we close the window with the X. 
	--if (questFrameIsShown and QuestGetAutoAccept()) then
	--	self:UpdateQuestFrameVisibility()
	--end

	local needUpdate -- we set this to true if something has changed
	local needZoneUpdate -- will return true if a new quest needs its zone data parsed
	local questHeader -- name of the current questlog- or zone header

	-- Store the user/wow selected quest in the questlog
	local selection = GetQuestLogSelection()

	-- Debugging shows this is working succesfully, picking up both added and removed quests. 
	-- My update problem is NOT here
	for questLogIndex = 1, numEntries do
		local questID, questTitle, questLevel, suggestedGroup, isHeader, isComplete, isFailed, isRepeatable = self:GetQuestLogTitle(questLogIndex)

		-- Remove level from quest title, if it exists. This applies to Legion emissary quests, amongst others. 
		-- *I used the quest title "[110] The Wardens" for my testing, because I suck at patterns. 
		if questTitle then
			questTitle = string.gsub(questTitle, "^(%[%d+%]%s+)", "")
		end

		if isHeader then
			-- Store the title of the current header, as this usually also is the zone name
			questHeader = questTitle

		-- Going to ignore all quests that are world quests here, 
		-- as we're tracking all of them separately.
		elseif (not ENGINE_LEGION) or (not QuestUtils_IsQuestWorldQuest(questID)) then

			-- Probably the same bug as the WotLK ones above, but since we didn't get
			-- the API call GetQuestID() until CATA, we're doing a double check here to be sure.
			--if (currentQuestID and (currentQuestID == questID)) then
			--	self:UpdateQuestFrameVisibility(isComplete)
			--end

			-- Select the entry in the quest log, for functions that require it to return info
			SelectQuestLogEntry(questLogIndex)

			-- Retrieve the existing quest database, if any 
			local currentQuestData = questData[questID] or {}

			-- If this is a new quest, report that we need an update
			if (not oldCache[questID]) then
				needZoneUpdate = true
				needUpdate = true
			end

			-- Cache up the current questID and log index
			newCache[questID] = questLogIndex

			local link, icon, charges, showItemWhenComplete = GetQuestLogSpecialItemInfo(questLogIndex) -- only an iconID in Legion, not a texture link
			local questCompletionText = isFailed and BLIZZ_LOCALE.QUEST_FAILED or GetQuestLogCompletionText(questLogIndex)
			local numQuestObjectives = GetNumQuestLeaderBoards(questLogIndex)
			local questDescription, questObjectivesDescription = GetQuestLogQuestText()

			local requiredMoney = GetQuestLogRequiredMoney(questLogIndex) or 0
			if (numQuestObjectives == 0) and (playerMoney >= requiredMoney) then
				isComplete = true
			end

			-- Update the quest objectives
			local questUpdated
			local questObjectives = currentQuestData.questObjectives or {}
			local numObjectivesCompleted = 0
			for i = 1, numQuestObjectives do
				
				local questObjective = questObjectives[i]
				if questObjective then
					local description, objectiveType, isCompleted, item, numCurrent, numNeeded = self:GetQuestLogLeaderBoard(i, questLogIndex)

					if not((description == questObjective.description) and (objectiveType == questObjective.objectiveType) and (isCompleted == questObjective.isCompleted) and (item == questObjective.item) and (numCurrent == questObjective.numCurrent) and (numNeeded == questObjective.numNeeded)) then

						-- Something was changed
						questUpdated = BLIZZ_LOCALE.UPDATE
					end

					questObjective.description = description
					questObjective.objectiveType = objectiveType
					questObjective.isCompleted = isCompleted
					questObjective.item = item
					questObjective.numCurrent = numCurrent
					questObjective.numNeeded = numNeeded
					
				else
					questObjective = {}

					-- new quest
					questObjective.description, 
					questObjective.objectiveType, 
					questObjective.isCompleted, 
					questObjective.item, 
					questObjective.numCurrent, 
					questObjective.numNeeded = self:GetQuestLogLeaderBoard(i, questLogIndex)

				end

				-- Needed for emissary quests to register as completed
				if (questObjective.item) and (questObjective.numCurrent == questObjective.numNeeded) and (questObjective.numNeeded > 0) then
					questObjective.isCompleted = true
				end
				if questObjective.isCompleted then
					numObjectivesCompleted = numObjectivesCompleted + 1
				end

				questObjectives[i] = questObjective
			end

			-- Can't really imagine why a quest's number of objectives should 
			-- change after creation, but just in case we wipe away any unneeded entries.
			-- Point is that we're using #questObjectives to determine number of objectives.
			for i = #questObjectives, numQuestObjectives + 1, -1 do
				if questObjectives[i] then
					table_wipe(questObjectives[i])
				end
			end

			-- If we're dealing with an update, figure out what kind. New quest? Failed? Completed? Updated objectives?
			currentQuestData.updateDescription = 
				(not questData[questID]) and BLIZZ_LOCALE.NEW or 
				(isComplete and (not currentQuestData.isComplete)) and BLIZZ_LOCALE.QUEST_COMPLETE or 
				(isFailed and (not currentQuestData.isFailed)) and BLIZZ_LOCALE.QUEST_FAILED or questUpdated

			currentQuestData.questID = questID
			currentQuestData.questTitle = questTitle
			currentQuestData.questLevel = questLevel
			--currentQuestData.questMapID = questMapID -- we're doing this later
			currentQuestData.questHeader = questHeader
			currentQuestData.suggestedGroup = suggestedGroup
			currentQuestData.isComplete = isComplete or (numObjectivesCompleted == numQuestObjectives)  
			currentQuestData.isFailed = isFailed
			currentQuestData.isRepeatable = isRepeatable
			currentQuestData.completionText = questCompletionText
			currentQuestData.numQuestObjectives = numQuestObjectives
			currentQuestData.questObjectives = questObjectives
			currentQuestData.questDescription = questDescription
			currentQuestData.questObjectivesDescription = questObjectivesDescription
			currentQuestData.requiredMoney = requiredMoney
			currentQuestData.icon = icon
			currentQuestData.hasQuestItem = icon and ((not isComplete) or showItemWhenComplete)
			currentQuestData.showItemWhenComplete = showItemWhenComplete

			-- Debugging why they won't sort, or register as completed
			--if questTitle:find("Wardens") then
			--	for k,v in pairs(currentQuestData) do print(k,v) end
			--end

			-- If anything was updated within this quest, report it back
			if (currentQuestData.updateDescription) then
				needUpdate = true
			end

			-- update pointer in case it was a newly added quest
			questData[questID] = currentQuestData
			
		end
	end

	-- Return the selected quest to whatever it was before our parsing.
	-- If we don't do this, hovering over quest rewards in the embedded worldmap 
	-- will bug out in client versions using the new map. 
	-- Return the selection to whatever the user or wow set it to seems to fix it.
	if (GetQuestLogSelection() ~= selection) then
		SelectQuestLogEntry(selection)
	end

	-- Point the questlog cache to our new table
	-- *Will this cause a big performance drop, creating a new one every update?
	--  Or can we get away with it, since it's just a single new one, not many? 
	questLogCache = newCache

	-- Report back if anything was changed and needs an update 
	return needUpdate, needZoneUpdate
end

Module.UpdateScale = function(self, event, ...)
	local arg = ...
	if (event == "CVAR_UPDATE") and (arg ~= "WINDOWED_MAXIMIZED") then
		return
	end
	if (event == "PLAYER_ENTERING_WORLD") then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD", "UpdateScale")
	end
	local pixelSize = UICenter:GetSizeOfPixel()
	if (PIXEL_SIZE ~= pixelSize) then
		local newBackdrop = getPixelPerfectBackdrop()
		for frame, backdrop in pairs(backdropCache) do
			local r, g, b, a = frame:GetBackdropColor()
			local r2, g2, b2, a2 = frame:GetBackdropBorderColor()
			frame:SetBackdrop(nil)
			frame:SetBackdrop(newBackdrop)
			frame:SetBackdropColor(r, g, b, a)
			frame:SetBackdropBorderColor(r2, g2, b2, a2)
		end
		PIXEL_SIZE = pixelSize
	end
end

Module.OnEvent = function(self, event, ...)

	-- Mainly used to get the initial quest caches up and running, 
	-- but also when changing continents, instances and such. 
	if (event == "PLAYER_ENTERING_WORLD") then
		-- Update stored quest log data
		self:GatherQuestLogData()

		-- Update stored world quest data
		if ENGINE_LEGION then
			self:GatherWorldQuestData()
		end
	end

	-- Called upon entering the world or changing zones or closing the map. 
	if (event == "PLAYER_ENTERING_WORLD") or (event == "ZONE_CHANGED_NEW_AREA") or (event == "WORLD_MAP_CLOSED") then
		-- Update map zone and quest zones in the cache
		-- This forces the map to the current zone, so it shouldn't be called otherwise.
		self:UpdateQuestZoneData()

		-- Update what quests we're tracking
		self:UpdateZoneTracking()
		self:UpdateTrackerWatches()

		-- Update the displayed tracker entries
		self:UpdateTrackerEntries()
		self:UpdateTrackerVisibility() -- make sure it's hidden in battlegrounds and arenas too
	end

	-- Something changed in the normal quest log
	if (event == "QUEST_LOG_UPDATE") then

		-- Parse the questlog and store the data
		self:GatherQuestLogData()

		-- Parse the available world quests
		if ENGINE_LEGION then
			self:GatherWorldQuestData()
		end

		-- Adding this here makes sure new questlog quests appear
		if (not WorldMapFrame:IsShown()) then
			self:UpdateQuestZoneData()
		end

		-- Update what quests we're tracking,
		-- since quests could have been added or removed here.
		self:UpdateZoneTracking()
		self:UpdateTrackerWatches()

		-- Update the displayed tracker entries
		self:UpdateTrackerEntries()
		self:UpdateTrackerVisibility()
	end

	-- The player entered a new subzone
	if (event == "ZONE_CHANGED") then
		local inMicroDungeon = IsPlayerInMicroDungeon and IsPlayerInMicroDungeon()
		if (inMicroDungeon ~= self.inMicroDungeon) then
			-- Inform the module we're in a micro dungeon.
			-- When implemented this will affect what objectives are shown,
			-- as we would like to track things only relevant to the dungeon, 
			-- or preferably none at all, thus keeping the screen clean. 
			self.inMicroDungeon = inMicroDungeon

			-- Parse the zone and what quests to track
			-- This requires log data to be loaded first
			self:UpdateZoneTracking()
			self:UpdateTrackerWatches()
	
			-- Update the displayed tracker entries
			self:UpdateTrackerEntries()
			self:UpdateTrackerVisibility()
		end
	end

	if (event == "WORLD_MAP_UPDATE") then
		-- This is where we register when the world map changes zone
		-- There are a TON of updates here, so we need to filter out the ones that matter
		if (self:GetCurrentMapAreaID() ~= CURRENT_MAP_ZONE) or (not CURRENT_MAP_ZONE) then

			-- Update what quests we're tracking
			self:UpdateZoneTracking()
			self:UpdateTrackerWatches()
	
			-- Update the displayed tracker entries
			self:UpdateTrackerEntries()
			self:UpdateTrackerVisibility()
		end
	end

	if ENGINE_CATA then
		-- Parse auto quest popups
		if (event == "PLAYER_ENTERING_WORLD") or (event == "ZONE_CHANGED") or (event == "ZONE_CHANGED_NEW_AREA") then
			self:ParseAutoQuests()
		end

		-- Super tracking update
		if (event == "QUEST_POI_UPDATE") then 
			--self:UpdateSuperTracking()
		end

		-- Auto completion and auto offering of quests
		if (event == "QUEST_AUTOCOMPLETE") then 
			PlaySound("UI_AutoQuestComplete")
			ShowQuestComplete(GetQuestLogIndexByID((...)))
		end
	end


end

Module.SetUpEvents = function(self, event, ...)
	-- Unregister whatever event brought us here
	self:UnregisterEvent(event, "SetUpEvents")

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEvent")
	self:RegisterEvent("ZONE_CHANGED", "OnEvent")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnEvent")
	self:RegisterEvent("QUEST_LOG_UPDATE", "OnEvent")
	self:RegisterEvent("WORLD_MAP_UPDATE", "OnEvent")

	--self:RegisterEvent("QUESTLINE_UPDATE", "OnEvent")
	
	self:RegisterEvent("QUEST_ACCEPTED", "OnEvent")
	self:RegisterEvent("QUEST_REMOVED", "OnEvent") -- local questID = ... -- fires on world quests

	--[[
	self:RegisterEvent("PLAYER_MONEY", "OnEvent")
	self:RegisterEvent("BAG_UPDATE", "OnEvent")
	self:RegisterEvent("BAG_UPDATE_COOLDOWN", "OnEvent")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED", "OnEvent")
	]]--

	-- Scale changes our pixel borders must watch out for
	self:RegisterEvent("UI_SCALE_CHANGED", "UpdateScale")
	self:RegisterEvent("DISPLAY_SIZE_CHANGED", "UpdateScale")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateScale")
	self:RegisterEvent("CVAR_UPDATE", "UpdateScale")

	-- Need some fake events to update quest zones 
	-- that couldn't be retrieved while the map was open
	WorldMapFrame:HookScript("OnHide", function() self:OnEvent("WORLD_MAP_CLOSED") end)
	WorldMapFrame:HookScript("OnShow", function() self:OnEvent("WORLD_MAP_OPENED") end)


	if ENGINE_CATA then
		-- Auto-accept and auto-completion introduced in Cata
		-- Quests could be automatically accepted in WotLK too, 
		-- but no specific events existed for it back then.
		self:RegisterEvent("QUEST_AUTOCOMPLETE", "OnEvent")
		self:RegisterEvent("QUEST_POI_UPDATE", "OnEvent") -- world quest update

		if ENGINE_WOD then
			--self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", "OnEvent") -- world quest update

			-- There are no events for world quests, 
			-- so the easiest way is to hook into the Blizzard API.
			-- Like with the world map, we create a dummy event here.
			-- *Need to figure out everything we need to hook this into.
			if ENGINE_LEGION then
				self:RegisterEvent("WORLD_QUEST_COMPLETED_BY_SPELL", "OnEvent") -- world quest update
				self:RegisterEvent("QUEST_TURNED_IN", "OnEvent") -- local questID, xp, money = ... -- fires on world quests
			end
		end
	end

	-- Do an initial full update
	self:OnEvent("PLAYER_ENTERING_WORLD")
end

Module.OnInit = function(self)
	self.config = self:GetStaticConfig("Objectives").tracker
	self.db = self:GetConfig("ObjectiveTracker") -- user settings. will save manually tracked quests here later.

	local config = self.config


	-- Tracker visibility layer
	-----------------------------------------------------------
	-- The idea here is that we simply do NOT want it visible while in an arena, 
	-- or while engaged in a boss fight.  
	-- We want as little clutter and distractions as possible during those 
	-- types of fights, and the quest tracker is simply just in the way then. 
	-- Same goes for pet battles in MoP and beyond. 
	local visibility = Engine:CreateFrame("Frame", nil, "UICenter", "SecureHandlerAttributeTemplate")
	if ENGINE_MOP then
		RegisterStateDriver(visibility, "visibility", "[petbattle][@boss1,exists][@arena1,exists]hide;show")
	else
		RegisterStateDriver(visibility, "visibility", "[@boss1,exists][@arena1,exists]hide;show")
	end

	-- Tracker frame
	-----------------------------------------------------------
	local tracker = setmetatable(visibility:CreateFrame("Frame"), Tracker_MT)
	--tracker:Hide() -- keep it initially hidden
	tracker:SetFrameStrata("LOW")
	tracker:SetFrameLevel(15)
	tracker.config = config
	tracker.entries = {} -- table to hold entries

	for i,point in ipairs(config.points) do
		tracker:Point(unpack(point))
	end

	-- Header region
	-----------------------------------------------------------
	local header = tracker:CreateFrame("Frame")
	header:SetHeight(config.header.height)
	for i,point in ipairs(config.header.points) do
		header:Point(unpack(point))
	end

	-- Tracker title
	local title = header:CreateFontString()
	title:SetDrawLayer("BACKGROUND")
	title:SetFontObject(config.header.title.normalFont)
	title:Place(unpack(config.header.title.position))
	title:SetText(BLIZZ_LOCALE.OBJECTIVES)

	-- Maximize/minimize button
	-- This needs to be secure, so we can use it to allow the user 
	-- to toggle the tracker visibility while engaged in combat, 
	-- even though the tracker contains secure actionbuttons 
	-- and otherwise can't be changed in combat. 
	-- I would write the whole trackre in secure code if I could, 
	-- but the API simply doesn't exist for that, so we compromise.
	local button = setmetatable(header:CreateFrame("Button"), MinMaxButton_MT)
	--local button = setmetatable(header:CreateFrame("Button", nil, "SecureHandlerClickTemplate"), MinMaxButton_MT)
	button:SetSize(unpack(config.header.button.size))
	button:Place(unpack(config.header.button.position))
	button:EnableMouse(true)
	button:RegisterForClicks("LeftButtonDown")

	local buttonMinimizeTexture = button:CreateTexture()
	buttonMinimizeTexture:SetAlpha(0)
	buttonMinimizeTexture:SetDrawLayer("BORDER")
	buttonMinimizeTexture:SetSize(unpack(config.header.button.textureSize))
	buttonMinimizeTexture:Place(unpack(config.header.button.texturePosition))
	buttonMinimizeTexture:SetTexture(config.header.button.textures.enabled)
	buttonMinimizeTexture:SetTexCoord(unpack(config.header.button.texcoords.minimized))

	local buttonMinimizeHighlightTexture = button:CreateTexture()
	buttonMinimizeHighlightTexture:SetAlpha(0)
	buttonMinimizeHighlightTexture:SetDrawLayer("BORDER")
	buttonMinimizeHighlightTexture:SetSize(unpack(config.header.button.textureSize))
	buttonMinimizeHighlightTexture:Place(unpack(config.header.button.texturePosition))
	buttonMinimizeHighlightTexture:SetTexture(config.header.button.textures.enabled)
	buttonMinimizeHighlightTexture:SetTexCoord(unpack(config.header.button.texcoords.minimizedHighlight))

	local buttonMaximizeTexture = button:CreateTexture()
	buttonMaximizeTexture:SetAlpha(0)
	buttonMaximizeTexture:SetDrawLayer("BORDER")
	buttonMaximizeTexture:SetSize(unpack(config.header.button.textureSize))
	buttonMaximizeTexture:Place(unpack(config.header.button.texturePosition))
	buttonMaximizeTexture:SetTexture(config.header.button.textures.enabled)
	buttonMaximizeTexture:SetTexCoord(unpack(config.header.button.texcoords.maximized))

	local buttonMaximizeHighlightTexture = button:CreateTexture()
	buttonMaximizeHighlightTexture:SetAlpha(0)
	buttonMaximizeHighlightTexture:SetDrawLayer("BORDER")
	buttonMaximizeHighlightTexture:SetSize(unpack(config.header.button.textureSize))
	buttonMaximizeHighlightTexture:Place(unpack(config.header.button.texturePosition))
	buttonMaximizeHighlightTexture:SetTexture(config.header.button.textures.enabled)
	buttonMaximizeHighlightTexture:SetTexCoord(unpack(config.header.button.texcoords.maximizedHighlight))

	local buttonDisabledTexture = button:CreateTexture()
	buttonDisabledTexture:SetAlpha(0)
	buttonDisabledTexture:SetDrawLayer("BORDER")
	buttonDisabledTexture:SetSize(unpack(config.header.button.textureSize))
	buttonDisabledTexture:Place(unpack(config.header.button.texturePosition))
	buttonDisabledTexture:SetTexture(config.header.button.textures.disabled)
	buttonDisabledTexture:SetTexCoord(unpack(config.header.button.texcoords.disabled))

	button.minimizeTexture = buttonMinimizeTexture
	button.minimizeHighlightTexture = buttonMinimizeHighlightTexture
	button.maximizeTexture = buttonMaximizeTexture
	button.maximizeHighlightTexture = buttonMaximizeHighlightTexture
	button.disabledTexture = buttonDisabledTexture


	-- Body region
	-----------------------------------------------------------
	local body = tracker:CreateFrame("Frame")
	body:Point("TOPLEFT", header, "BOTTOMLEFT", 0, -4)
	body:Point("TOPRIGHT", header, "BOTTOMRIGHT", 0, -4)
	body:Point("BOTTOMLEFT", 0, 0)
	body:Point("BOTTOMRIGHT", 0, 0)


	-- Apply scripts
	-----------------------------------------------------------
	button.body = body
	button.currentState = "maximized" -- todo: save this between sessions(?)

	button:SetScript("OnEnter", MinMaxButton.UpdateLayers)
	button:SetScript("OnLeave", MinMaxButton.UpdateLayers)
	button:SetScript("OnEnable", MinMaxButton.UpdateLayers)
	button:SetScript("OnDisable", MinMaxButton.UpdateLayers)
	button:SetScript("OnClick", MinMaxButton.OnClick)
	button:UpdateLayers()
	

	tracker.header = header
	tracker.body = body
	
	self.tracker = tracker

end

Module.OnEnable = function(self)

	-- kill off the blizzard objectives tracker 
	local BlizzardUI = self:GetHandler("BlizzardUI")
	BlizzardUI:GetElement("ObjectiveTracker"):Disable()
	BlizzardUI:GetElement("Menu_Option"):Remove(true, "InterfaceOptionsObjectivesPanelWatchFrameWidth")

	-- No real need to track any events at all prior to this
	if ENGINE_MOP then
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "SetUpEvents")
	else
		-- Prior to MoP quest data wasn't available until this event
		self:RegisterEvent("PLAYER_ALIVE", "SetUpEvents")
	end

	-- Hide the tracker initially
	self:UpdateTrackerVisibility()
end
