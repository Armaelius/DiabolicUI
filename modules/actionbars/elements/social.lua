local _, Engine = ...
local Module = Engine:GetModule("ActionBars")
local MenuWidget = Module:SetWidget("Menu: Chat")
local L = Engine:GetLocale()

-- Lua API
local setmetatable = setmetatable

-- WoW API
local CreateFrame = CreateFrame
local PlaySoundKitID = Engine:IsBuild("7.3.0") and _G.PlaySound or _G.PlaySoundKitID

-- WoW Frames & Objects
local GameTooltip = _G.GameTooltip

-- WoW Client Constants
local ENGINE_CATA = Engine:IsBuild("Cata")

MenuWidget.Skin = function(self, button, config, icon)
	local icon_config = Module.config.visuals.menus.icons

	button.Normal = button:CreateTexture(nil, "BORDER")
	button.Normal:ClearAllPoints()
	button.Normal:SetPoint(unpack(config.button.texture_position))
	button.Normal:SetSize(unpack(config.button.texture_size))
	button.Normal:SetTexture(config.button.textures.normal)
	
	button.Pushed = button:CreateTexture(nil, "BORDER")
	button.Pushed:Hide()
	button.Pushed:ClearAllPoints()
	button.Pushed:SetPoint(unpack(config.button.texture_position))
	button.Pushed:SetSize(unpack(config.button.texture_size))
	button.Pushed:SetTexture(config.button.textures.pushed)

	button.Icon = button:CreateTexture(nil, "OVERLAY")
	button.Icon:SetSize(unpack(icon_config.size))
	button.Icon:SetPoint(unpack(icon_config.position))
	button.Icon:SetAlpha(icon_config.alpha)
	button.Icon:SetTexture(icon_config.texture)
	button.Icon:SetTexCoord(unpack(icon_config.texcoords[icon]))
	
	local position = icon_config.position
	local position_pushed = icon_config.pushed.position
	local alpha = icon_config.alpha
	local alpha_pushed = icon_config.pushed.alpha

	button.OnButtonState = function(self, state, lock)
		if state == "PUSHED" then
			self.Pushed:Show()
			self.Normal:Hide()
			self.Icon:ClearAllPoints()
			self.Icon:SetPoint(unpack(position_pushed))
			self.Icon:SetAlpha(alpha_pushed)
		else
			self.Normal:Show()
			self.Pushed:Hide()
			self.Icon:ClearAllPoints()
			self.Icon:SetPoint(unpack(position))
			self.Icon:SetAlpha(alpha)
		end
	end
	hooksecurefunc(button, "SetButtonState", button.OnButtonState)

	button:SetHitRectInsets(0, 0, 0, 0)
	button:OnButtonState(button:GetButtonState())
end

MenuWidget.OnEnable = function(self)
	local config = Module.config
	local db = Module.db

	local Menu = Module:GetWidget("Controller: Chat"):GetFrame()
	local MenuButton = Module:GetWidget("Template: MenuButton")
	local FlyoutBar = Module:GetWidget("Template: FlyoutBar")

	-- WoW Frames and Objects
	local InputBox = ChatFrame1EditBox
	local FriendsMicroButton = FriendsMicroButton or QuickJoinToastButton -- changed name in Legion
	local FriendsWindow = FriendsFrame

	-- config table shortcuts
	local chat_menu_config = config.structure.controllers.chatmenu
	local input_config = config.visuals.menus.chat.input
	local menu_config = config.visuals.menus.chat.menu

	-- Main Buttons
	---------------------------------------------
	local ChatButton = MenuButton:New(Menu)
	ChatButton:SetPoint("BOTTOMLEFT")
	ChatButton:SetSize(unpack(input_config.button.size))

	self:Skin(ChatButton, input_config, "chat")


	InputBox:HookScript("OnShow", function() 
		ChatButton:SetButtonState("PUSHED", 1)
		PlaySoundKitID(SOUNDKIT.IG_CHARACTER_INFO_OPEN, "SFX")
	end)
	InputBox:HookScript("OnHide", function() 
		ChatButton:SetButtonState("NORMAL") 
		PlaySoundKitID(SOUNDKIT.IG_CHARACTER_INFO_CLOSE, "SFX")
	end)


	local SocialButton = MenuButton:New(Menu)
	SocialButton:SetPoint("BOTTOMLEFT", ChatButton, "BOTTOMRIGHT", chat_menu_config.padding, 0 )
	SocialButton:SetSize(unpack(input_config.button.size))
	self:Skin(SocialButton, input_config, "group")

	
	FriendsWindow:HookScript("OnShow", function() SocialButton:SetButtonState("PUSHED", 1) end)
	FriendsWindow:HookScript("OnHide", function() SocialButton:SetButtonState("NORMAL") end)

	ChatButton.OnEnter = function(self) 
		if GameTooltip:IsForbidden() then
			return
		end
		if ChatButton:GetButtonState() == "PUSHED"
		or SocialButton:GetButtonState() == "PUSHED" then
			GameTooltip:Hide()
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 6, 16)
		GameTooltip:AddLine(L["Chat"])
		GameTooltip:AddLine(L["<Left-click> or <Enter> to chat."], 0, .7, 0)
		GameTooltip:Show()
	end
	ChatButton:SetScript("OnEnter", ChatButton.OnEnter)
	ChatButton:SetScript("OnLeave", function(self) 
		if GameTooltip:IsForbidden() then
			return
		end
		GameTooltip:Hide() 
	end)
	
	ChatButton.OnClick = function(self, button)
		if InputBox:IsShown() then
			InputBox:Hide()
		else
			InputBox:Show() 
			InputBox:SetFocus()
		end
		if button == "LeftButton" then
			self:OnEnter() -- update tooltips
		end
	end
	ChatButton:SetAttribute("_onclick", [[ control:CallMethod("OnClick", button); ]])
	
	
	SocialButton.OnEnter = function(self) 
		if GameTooltip:IsForbidden() then
			return
		end

		local numTotalGuildMembers, numOnlineGuildMembers, numOnlineAndMobileMembers = GetNumGuildMembers()
		local numberOfFriends, onlineFriends = GetNumFriends() 
		local numGuildies = numOnlineAndMobileMembers or numOnlineGuildMembers or 0

		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 6, 16)
		GameTooltip:AddLine(((numTotalGuildMembers > 0) or (not ENGINE_CATA)) and L["Friends & Guild"] or FRIENDS)

		if (numGuildies > 1) or (onlineFriends > 0) then
			GameTooltip:AddLine(" ")
			if (numGuildies > 1) then
				GameTooltip:AddDoubleLine(L["Guild Members Online:"], numGuildies, 1,1,1,1,.82,0)
			end
			if (onlineFriends > 0) then
				GameTooltip:AddDoubleLine(L["Friends Online:"], onlineFriends, 1,1,1,1,.82,0)
			end
			GameTooltip:AddLine(" ")
		end

		GameTooltip:AddLine(L["<Left-click> to toggle social frames."], 0, .7, 0)
		GameTooltip:AddLine(L["<Right-click> to toggle Guild frame."], 0, .7, 0)
		GameTooltip:Show()
	end
	SocialButton:SetScript("OnEnter", SocialButton.OnEnter)
	SocialButton:SetScript("OnLeave", function(self) 
		if GameTooltip:IsForbidden() then
			return
		end
		GameTooltip:Hide() 
	end)
	
	SocialButton.OnClick = function(self, button)
		if (button == "LeftButton") then
			FriendsMicroButton:GetScript("OnClick")(FriendsMicroButton, button)
		elseif (button == "RightButton") then
			GuildMicroButton:GetScript("OnClick")(GuildMicroButton, button)
		end 
	end
	SocialButton:SetAttribute("_onclick", [[ control:CallMethod("OnClick", button); ]])


	-- Texts
	---------------------------------------------
	local Gold = ChatButton:CreateFontString()
	Gold:SetDrawLayer("ARTWORK")
	Gold:SetFontObject(input_config.people.normalFont)
	Gold:SetPoint(unpack(input_config.people.position))
	ChatButton.Gold = Gold

	ChatButton:SetScript("OnEvent", function(self, event, ...) 
		local money = GetMoney()
		self.Gold:SetFormattedText(("%d|cffc98910g|r %d|cffa8a8a8s|r %d|cffb87333c|r"):format(money / 100 / 100, (money / 100) % 100, money % 100))
		--self.Gold:SetFormattedText(("|cffc98910%d|r . |cffa8a8a8%d|r . |cffb87333%d|r"):format(money / 100 / 100, (money / 100) % 100, money % 100))
	end)

	ChatButton:RegisterEvent("PLAYER_MONEY")
	ChatButton:RegisterEvent("PLAYER_ENTERING_WORLD")


	local People = SocialButton:CreateFontString()
	People:SetDrawLayer("ARTWORK")
	People:SetFontObject(menu_config.people.normalFont)
	People:SetPoint(unpack(menu_config.people.position))

	local numTotalGuildMembers, numOnlineGuildMembers, numOnlineAndMobileMembers = GetNumGuildMembers()
	local numberOfFriends, onlineFriends = GetNumFriends() 

	SocialButton.numFriends = onlineFriends
	SocialButton.numGuildies = numOnlineAndMobileMembers or numOnlineGuildMembers or 0
	SocialButton.totalGuildies = numTotalGuildMembers
	SocialButton.People = People

	SocialButton:SetScript("OnEvent", function(self, event, ...) 
		local arg1 = ...

		local numTotalGuildMembers, numOnlineGuildMembers, numOnlineAndMobileMembers = GetNumGuildMembers()
		local numberOfFriends, onlineFriends = GetNumFriends() 
		local numPeople = self.numFriends + self.numGuildies

		self.numGuildies = numOnlineAndMobileMembers or numOnlineGuildMembers or 0
		self.totalGuildies = numTotalGuildMembers
		self.numFriends = onlineFriends
		self.People:SetText(numPeople > 1 and numPeople or "")
	end)

	SocialButton:RegisterEvent("GUILD_ROSTER_UPDATE")
	SocialButton:RegisterEvent("PLAYER_ENTERING_WORLD")



end
