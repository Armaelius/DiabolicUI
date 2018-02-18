local Addon, Engine = ...
local Module = Engine:GetModule("UnitFrames")
local UnitFrameWidget = Module:SetWidget("Unit: Party")

local UnitFrame = Engine:GetHandler("UnitFrame")
local StatusBar = Engine:GetHandler("StatusBar")
local C = Engine:GetDB("Data: Colors")

-- Lua API
local _G = _G
local pairs = pairs
local string_match = string.match
local table_concat = table.concat
local table_insert = table.insert
local tostring = tostring
local unpack = unpack

-- WoW API
local UnitClass = _G.UnitClass


local postUpdateHealth = function(health, unit, curHealth, maxHealth, isUnavailable)

	local r, g, b
	if (not isUnavailable) then
		if UnitIsPlayer(unit) then
			local _, class = UnitClass(unit)
			r, g, b = unpack(class and C.Class[class] or C.Class.UNKNOWN)
		elseif UnitPlayerControlled(unit) then
			if UnitIsFriend("player", unit) then
				r, g, b = unpack(C.Reaction[5])
			elseif UnitIsEnemy(unit, "player") then
				r, g, b = unpack(C.Reaction[1])
			else
				r, g, b = unpack(C.Reaction[4])
			end
		elseif (not UnitIsFriend("player", unit)) and UnitIsTapDenied(unit) then
			r, g, b = unpack(C.Status.Tapped)
		elseif UnitReaction(unit, "player") then
			r, g, b = unpack(C.Reaction[UnitReaction(unit, "player")])
		else
			r, g, b = unpack(C.Orb.HEALTH[1])
		end
	elseif (isUnavailable == "dead") or (isUnavailable == "ghost") then
		r, g, b = unpack(C.Status.Dead)
	elseif (isUnavailable == "offline") then
		r, g, b = unpack(C.Status.Disconnected)
	end

	if r then
		if not((r == health.r) and (g == health.g) and (b == health.b)) then
			health:SetStatusBarColor(r, g, b)
			health.r, health.g, health.b = r, g, b
		end
	end

end

local Style = function(self, unit)
	local config = Module:GetDB("UnitFrames").visuals.units.party
	local db = Module:GetConfig("UnitFrames") 

	--self:Size(unpack(config.size))
	--self:Place(unpack(config.position))

	local unitNum = string_match(unit, "%d")

	self:Size(160, 80)
	self:Place("TOP", 0, -((unitNum-1) * 90))

	local path = ([[Interface\AddOns\%s\media\]]):format(Addon)

	-- Artwork
	-------------------------------------------------------------------


	-- Health
	-------------------------------------------------------------------
	local Health = self:CreateStatusBar()
	Health:SetSize()
	Health:SetPoint()
	Health:SetStatusBarTexture(path .. [[statusbars\DiabolicUI_StatusBar_512x64_Dark_Warcraft.tga]])
	Health.frequent = 1/120

	-- Power
	-------------------------------------------------------------------
	--local Power = StatusBar:New(self)
	--Power:SetSize(unpack(config.power.size))
	--Power:SetPoint(unpack(config.power.position))
	--Power:SetStatusBarTexture(config.power.texture)
	--Power.frequent = 1/120
	

	-- CastBar
	-------------------------------------------------------------------
	local CastBar = StatusBar:New(Health)
	CastBar:Hide()
	CastBar:SetAllPoints()
	CastBar:SetStatusBarTexture(1, 1, 1, .15)
	CastBar:SetSize(Health:GetSize())
	CastBar:DisableSmoothing(true)


	self.Health = Health
	self.Power = Power

end 

UnitFrameWidget.OnEnable = function(self)
	local config = self:GetDB("UnitFrames").visuals.units.party
	local db = self:GetConfig("UnitFrames") 

	self.UnitFrame = self:CreateFrame("Frame")
	self.UnitFrame:Place("TOPLEFT", "UICenter", "TOPLEFT", 60, -50)
	self.UnitFrame:SetSize(2,2)

	for i = 1,4 do 
		local unitFrame = UnitFrame:New("party"..i, self.UnitFrame, Style) 

		self.UnitFrame[i] = unitFrame
	end 

end 

UnitFrameWidget.GetFrame = function(self, numPartyMember)
	return self.UnitFrame[numPartyMember] or self.UnitFrame
end
