local _, Engine = ...

-- This database will contain lists of categorized Auras
-- for CC, dispellers and so on. 

local auras = {
	-- whitelisted auras mainly for the target frame
	whitelist = {

	},
	cc = {},
	harm = {},
	help = {},
	zone = {
		[64373] = true -- Armistice (Argent Tournament Zone Buff)
	}
}


Engine:NewStaticConfig("Data: Auras", auras)