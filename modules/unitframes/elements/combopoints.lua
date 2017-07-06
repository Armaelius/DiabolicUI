local _, Engine = ...
local Handler = Engine:GetHandler("UnitFrame")

-- Lua API
local _G = _G
local select = select
local table_insert = table.insert

-- WoW API
local GetComboPoints = _G.GetComboPoints
local IsPlayerSpell = _G.IsPlayerSpell -- added in 5.0.4
local UnitBuff = _G.UnitBuff
local UnitClass = _G.UnitClass
local UnitExists = _G.UnitExists
local UnitPower = _G.UnitPower
local UnitPowerMax = _G.UnitPowerMax
local UnitHasVehicleUI = _G.UnitHasVehicleUI

local ENGINE_WOTLK = Engine:IsBuild("WotLK")
local ENGINE_CATA = Engine:IsBuild("Cata")
local ENGINE_MOP = Engine:IsBuild("MoP")
local ENGINE_LEGION = Engine:IsBuild("Legion")

local _, CLASS = UnitClass("player")

--[[

-- What point based resources do various classes have?
-- (Source: http://www.mmo-champion.com/threads/2059860-Primary-and-Secondary-Resources-Guide)
-------------------------------------------------------------------------------------------------------

Legion:
	Chi: 			Generated points. 4 cap, 5 if talented, 0 baseline
	Combo Points: 	Fast generated points. 5 cap, 6 if talented, 0 baseline
	Holy Power: 	Fast generated points. 3 cap, 0 baseline
	Runes: 			Self, fast refilling points. 6 cap, 6 baseline
	Soul Shards: 	Slowly generated points. 5 cap, 1 point baseline


MoP:
	Arcane Charges
	Burning Embers
	Chi
	Combo Points
	Holy Power
	Runes
	Shadow Orbs
	Soul Shards


Cata: 
	Combo Points
	Holy Power
	Runes
	Soul Shards


WotLK:
	Combo Points
	Holy Power
	Runes



]]--

local Bar = {}
local Bar_MT = { __index = Bar }

local ArcaneChargeBar = setmetatable({}, { __index = Bar })
local ArcaneChargeBar_MT = { __index = ArcaneChargeBar }

local BurningEmbersBar = setmetatable({}, { __index = Bar })
local BurningEmbersBar_MT = { __index = BurningEmbersBar }

local ChiBar = setmetatable({}, { __index = Bar })
local ChiBar_MT = { __index = ChiBar }

local ComboBar = setmetatable({}, { __index = Bar })
local ComboBar_MT = { __index = ComboBar }

local ChiBar = setmetatable({}, { __index = Bar })
local ChiBar_MT = { __index = ChiBar }

local HolyPowerBar = setmetatable({}, { __index = Bar })
local HolyPowerBar_MT = { __index = HolyPowerBar }

local HolyPowerBar = setmetatable({}, { __index = Bar })
local HolyPowerBar_MT = { __index = HolyPowerBar }

local ShadowOrbBar = setmetatable({}, { __index = Bar })
local ShadowOrbBar_MT = { __index = ShadowOrbBar }

local SoulShardBar = setmetatable({}, { __index = Bar })
local SoulShardBar_MT = { __index = SoulShardBar }




local Point = {}
local Point_MT = { __index = Point }

local ArcaneChargePoint = setmetatable({}, { __index = Point })
local ArcaneChargePoint_MT = { __index = ArcaneChargePoint }

local BurningEmberPoint = setmetatable({}, { __index = Point })
local BurningEmberPoint_MT = { __index = BurningEmberPoint }

local ChiPoint = setmetatable({}, { __index = Point })
local ChiPoint_MT = { __index = ChiPoint }

local ComboPoint = setmetatable({}, { __index = Point })
local ComboPoint_MT = { __index = ComboPoint }

local HolyPowerPoint = setmetatable({}, { __index = Point })
local HolyPowerPoint_MT = { __index = HolyPowerPoint }

local RunePoint = setmetatable({}, { __index = Point })
local RunePoint_MT = { __index = RunePoint }

local ShadowOrbPoint = setmetatable({}, { __index = Point })
local ShadowOrbPoint_MT = { __index = ShadowOrbPoint }

local SoulShardPoint = setmetatable({}, { __index = Point })
local SoulShardPoint_MT = { __index = SoulShardPoint }






---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
-- 					OLD FILE BELOW THIS POINT!!! 
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Uncomment to disable old system while testing.
--do return end

local PlayerIsRogue = select(2, UnitClass("player")) == "ROGUE" -- to check for rogue anticipation
local PlayerIsDruid = select(2, UnitClass("player")) == "DRUID" -- we won't be needing this. leaving it here because. druid. master race.

-- Disabling for now, since it's bugged.
-- *This is just temporary, so the UI doesn't break while I rewrite it! 
if PlayerIsRogue and ENGINE_MOP then
	return
end

local OldAnticipation = PlayerIsRogue and ENGINE_MOP and (not ENGINE_LEGION)
local NewAnticipation = PlayerIsRogue and ENGINE_LEGION -- anticipation changed in Legion, so did combopoints

local MAX_COMBO_POINTS
local MAX_ANTICIPATION_POINTS
local Anticipation_Talent, HasAnticipation
local anticipation

if OldAnticipation then
	MAX_COMBO_POINTS = 5
	MAX_ANTICIPATION_POINTS = 5
	
	-- Rogue Anticipation is a Level 90 Talent added in patch 5.0.4. 
	-- 	*We're checking for the anticipation buff by its name, 
	-- 	 but I don't want this to require any localization to function.  
	-- 	 So to make sure we catch the correct spell, we check both for the buff, 
	-- 	 the spell that activates it, and even the talent that causes it. 
	--   I mean... one of them HAS to be right in every client language, right? :/
	anticipation = {}
	table_insert(anticipation, (GetSpellInfo(115190))) -- the buff the rogue gets
	table_insert(anticipation, (GetSpellInfo(115189))) -- the ability that triggers
	table_insert(anticipation, (GetSpellInfo(114015))) -- the rogue talent from MoP 5.0.4

	Anticipation_Talent = 114015
	HasAnticipation = ENGINE_MOP and PlayerIsRogue and IsPlayerSpell(Anticipation_Talent)
	
elseif NewAnticipation then
	MAX_COMBO_POINTS = 6
	MAX_ANTICIPATION_POINTS = 3
else
	MAX_COMBO_POINTS = 5
	MAX_ANTICIPATION_POINTS = nil
end

	
local Update = function(self, event, ...)
	local unit = self.unit
	if unit == "pet" then 
		return 
	end
	local ComboPoints = self.ComboPoints
	
	local cp, cp_max
	local ap, ap_max

	local vehicle = UnitHasVehicleUI("player")
	local combo_unit = vehicle and "vehicle" or "player"

	-- In Legion anticipation is merely 3 more combopoints
	if ENGINE_LEGION then
		cp = UnitPower(combo_unit, SPELL_POWER_COMBO_POINTS)
		cp_max = UnitPowerMax(combo_unit, SPELL_POWER_COMBO_POINTS)
		if cp_max == 8 then
			cp_max = 5
			ap_max = 3
			if cp > 5 then
				ap = cp - 5
				cp = 5
			end
		else
			ap = 0
			ap_max = 0
		end
		
	-- in MoP and WoD, anticipation was a double set of combopoints
	elseif ENGINE_MOP then
		cp = GetComboPoints(combo_unit, "target") 
		cp_max = 5
		if HasAnticipation and not vehicle then
			ap_max = 5
			for i,name in ipairs(anticipation) do
				ap = select(4, UnitBuff("player", name, nil)) or 0
				if ap > 0 then
					break
				end
			end
		end
	else
		cp = GetComboPoints(combo_unit, "target") 
		cp_max = 5
	end

	for i = 1, cp_max do
		if i <= cp then
			ComboPoints[i]:Show()
		else
			ComboPoints[i]:Hide()
		end
	end
	
	-- might have been a spec change, changing max from 6 to 5
	if ENGINE_LEGION then
		if #ComboPoints > cp_max then
			for i = cp_max + 1, #ComboPoints do
				ComboPoints[i]:Hide()
			end
		end
	end
	
	if ap and ap_max then
		local Anticipation = self.ComboPoints.Anticipation
		if Anticipation then
			for i = 1, ap_max do
				if i <= ap then
					Anticipation[i]:Show()
				else
					Anticipation[i]:Hide()
				end
			end
		end
	end
	
	if ComboPoints.PostUpdate then
		return ComboPoints:PostUpdate()
	end
end

local SpellsChanged = function(self, event, ...)
	if not HasAnticipation and IsPlayerSpell(Anticipation_Talent) then
		HasAnticipation = true
		self:RegisterEvent("UNIT_AURA", Update)
	end
	if HasAnticipation and not IsPlayerSpell(Anticipation_Talent) then
		HasAnticipation = false
		self:UnregisterEvent("UNIT_AURA", Update)
	end
	Update(self, event, ...)
end

local Enable = function(self, unit)
	local ComboPoints = self.ComboPoints
	if ComboPoints then
		self:RegisterEvent("PLAYER_ENTERING_WORLD", Update)
		self:RegisterEvent("PLAYER_TARGET_CHANGED", Update)

		if ENGINE_LEGION then
			self:RegisterEvent("UNIT_POWER_FREQUENT", Update)
			self:RegisterEvent("UNIT_MAXPOWER", Update)
		else
			self:RegisterEvent("UNIT_COMBO_POINTS", Update)
			if ENGINE_MOP and PlayerIsRogue then
				self:RegisterEvent("SPELLS_CHANGED", SpellsChanged)
				
				if HasAnticipation then
					self:RegisterEvent("UNIT_AURA", Update)
				end
			end
		end
		return true
	end
end

local Disable = function(self, unit)
	local ComboPoints = self.ComboPoints
	if ComboPoints then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD", Update)
		self:UnregisterEvent("PLAYER_TARGET_CHANGED", Update)
		
		if ENGINE_LEGION then
			self:UnregisterEvent("UNIT_POWER_FREQUENT", Update)
			self:UnregisterEvent("UNIT_MAXPOWER", Update)
		else
			self:UnregisterEvent("UNIT_COMBO_POINTS", Update)
			if ENGINE_MOP and PlayerIsRogue then
				self:UnregisterEvent("SPELLS_CHANGED", SpellsChanged)

				if HasAnticipation then
					self:UnregisterEvent("UNIT_AURA", Update)
				end
			end
		end
	end
end

Handler:RegisterElement("ComboPoints", Enable, Disable, Update)