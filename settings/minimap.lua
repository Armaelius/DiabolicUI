local Addon, Engine = ...
local C = Engine:GetStaticConfig("Data: Colors")
local path = ([[Interface\AddOns\%s\media\]]):format(Addon)
local MINIMAP_SIZE = Engine:GetConstant("MINIMAP_SIZE") 

-- WoW Client Constants
local ENGINE_LEGION_730 = Engine:IsBuild("7.3.0")
local ENGINE_LEGION_725 = Engine:IsBuild("7.2.5")
local ENGINE_LEGION_715 = Engine:IsBuild("7.1.5")
local ENGINE_WOD = Engine:IsBuild("WoD")
local ENGINE_MOP = Engine:IsBuild("MoP")
local ENGINE_CATA = Engine:IsBuild("Cata")

-- Using this to figure out blip texture content and ratio
--local blips = UIParent:CreateTexture()
--blips:SetDrawLayer("ARTWORK")
--blips:SetSize(128,128)
--blips:SetPoint("CENTER")
--blips:SetTexture([[Interface\MiniMap\ObjectIconsAtlas]]) -- Legion 
--blips:SetTexture([[Interface\Minimap\ObjectIcons.blp]]) -- others

Engine:NewStaticConfig("Minimap", {
	size = { MINIMAP_SIZE, MINIMAP_SIZE }, 
	point = { "TOPRIGHT", "UICenter", "TOPRIGHT", -20, -84 }, 
	map = {
		size = { MINIMAP_SIZE, MINIMAP_SIZE }, 
		point = { "CENTER", 0, 0 },
		mask = path..[[textures\DiabolicUI_MinimapCircularMaskSemiTransparent.tga]],
		blips = ENGINE_LEGION_730 and path..[[textures\Blip-Nandini-New-730.tga]] -- Legion 7.3.0
			or ENGINE_LEGION_725 and path..[[textures\Blip-Nandini-New-725.tga]] -- Legion 7.2.5 
			or ENGINE_LEGION_715 and path..[[textures\Blip-Nandini-New-715.tga]] -- Legion 7.1.5 (WoW-Freakz)
			or ENGINE_WOD and path..[[textures\Blip-Nandini-New-622.tga]] -- late WoD
			or ENGINE_MOP and path..[[textures\Blip-Nandini-New-548.tga]] -- late MoP (Warmane)
			or (not ENGINE_CATA) and path..[[textures\Blip-Nandini-New-335.tga]] -- WotLK (Warmane)
			or [[Interface\Minimap\ObjectIcons.blp]] -- Fallback. Default blizzard location.
	},
	border = {
		size = { 512, 512 },
		point = { "CENTER", 0, 0 },
		path = path..[[textures\DiabolicUI_Minimap_CircularBorder.tga]]
	},
	widgets = {
		buttonBag = {
			size = { 32, 32 },
			point = { "TOPRIGHT", 0, 0 },
			texture = path .. [[textures\DiabolicUI_Texture_32x32_WhitePlusRounded_Warcraft.tga]]
		},
		group = {
			size = { 54, 54 },
			point = { "BOTTOMLEFT", 10, -16 },

			border_size = { 128, 128 },
			border_point = { "CENTER", 0, 0 },
			border_texture = path .. [[textures\DiabolicUI_MinimapIcon_Circular.tga]],
			border_texcoord = { 0/64, 64/64, 0/64, 64/64 },

			icon_size = { 40, 40 },
			icon_point = { "CENTER", 0, 0 },
			icon_texture = path .. [[textures\DiabolicUI_40x40_MenuIconGrid.tga]],
			icon_texcoord = { 120/255, 159/255, 40/255, 79/255 },

			--size = { 60, 30 },
			--point = { "BOTTOMLEFT", "Minimap", "BOTTOMLEFT", 16.5, 4.5 }, 
			--fontAnchor = { "BOTTOMLEFT", "Minimap", "BOTTOMLEFT", 16.5, 13.5 },
			--fontColor = C.General.Highlight, 
			--normalFont = DiabolicFont_SansRegular12
		},
		mail = {
			size = { 40, 40 },
			point = { "BOTTOMRIGHT", -12, 10 }, 
			texture = path .. [[textures\DiabolicUI_40x40_MenuIconGrid.tga]],
			texture_size = { 256, 256 },
			texcoord = { 0/255, 39/255, 120/255, 159/255 }
		},
		worldmap = {
			size = { 40, 40 },
			point = { "TOPRIGHT", -12, -10 }, 
			texture = path .. [[textures\DiabolicUI_40x40_MenuIconGrid.tga]],
			texture_size = { 256, 256 },
			texcoord = { 200/255, 239/255, 0/255, 39/255 }
		}
	},
	text = {
		zone = {
			point = { "TOPRIGHT", "UICenter", "TOPRIGHT", -23.5, -(10.5 + 12) },
			normalFont = DiabolicFont_HeaderRegular16
		},
		time = {
			point = { "TOPRIGHT", "UICenter", "TOPRIGHT", -23.5, -(30.5 + 10) },
			normalFont = DiabolicFont_SansRegular14
		},
		coordinates = {
			point = { "BOTTOM", "Minimap", "BOTTOM", 0, 12.5 + 10 },
			normalFont = DiabolicFont_SansRegular12
		}
	}
})
