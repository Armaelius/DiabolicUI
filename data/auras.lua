local _, Engine = ...

-- This database will contain lists of categorized Auras
-- for CC, dispellers and so on. 

local auras = {
	-- whitelisted auras mainly for the target frame
	whitelist = {

	},
	dr = {
		-- seconds after last application before vulnerable again
		reset = 18,
		resetKnockback = 10,

		-- part of the normal duration on the [i]th application 
		duration = {1.0, 0.5, 0.25, 0.0},
		durationTaunt = {1.0, 0.65, 0.42, 0.27, 0.0},
		durationKnockback = {1.0, 0.0},
	},
	cc = {
		incapacitate = {
			[    99] = true,  -- Druid - Incapacitating Roar
			[203126] = true,  -- Druid - Maim
			[209790] = true,  -- Hunter - Freezing Arrow
			[  3355] = true,  -- Hunter - Freezing Trap
			[ 19386] = true,  -- Hunter - Wyvern Sting
			[   118] = true,  -- Mage - Polymorph
			[ 28271] = true,  -- Mage - Polymorph (Turtle)
			[ 28272] = true,  -- Mage - Polymorph (Pig)
			[ 61305] = true,  -- Mage - Polymorph (Black Cat)
			[ 61721] = true,  -- Mage - Polymorph (Rabbit)
			[ 61780] = true,  -- Mage - Polymorph (Turkey)
			[126819] = true,  -- Mage - Polymorph (Porcupine)
			[161353] = true,  -- Mage - Polymorph (Polar Cub)
			[161354] = true,  -- Mage - Polymorph (Monkey)
			[161355] = true,  -- Mage - Polymorph (Penguin)
			[161372] = true,  -- Mage - Polymorph (Peacock)
			[ 82691] = true,  -- Mage - Ring of Frost
			[115078] = true,  -- Monk - Paralysis
			[ 20066] = true,  -- Paladin - Repentance
			[200196] = true,  -- Priest - Holy Word: Chastise
			[  9484] = true,  -- Priest - Shackle Undead
			[  1776] = true,  -- Rogue - Gouge
			[  6770] = true,  -- Rogue - Sap
			[ 51514] = true,  -- Shaman - Hex
			[210873] = true,  -- Shaman - Hex (Compy)
			[211004] = true,  -- Shaman - Hex (Spider)
			[211010] = true,  -- Shaman - Hex (Snake)
			[211015] = true,  -- Shaman - Hex (Cockroach)
			[   710] = true,  -- Warlock - Banish
			[  6789] = true,  -- Warlock - Mortal Coil
			
			[107079] = true, -- Pandarian - Quaking Palm
		},
		disorient = {
			[207167] = true,  -- Death Knight - Blinding Sleet
			[207685] = true,  -- Demon Hunter - Sigil of Misery
			[ 33786] = true,  -- Druid - Cyclone
			[186387] = true,  -- Hunter - Bursting Shot
			[213691] = true,  -- Hunter - Scatter Shot
			[ 31661] = true,  -- Mage - Dragon's Breath
			[198909] = true,  -- Monk - Song of Chi-Ji
			[202274] = true,  -- Monk - Incendiary Brew
			[105421] = true,  -- Paladin - Blinding Light
			[   605] = true,  -- Priest - Dominate Mind
			[  8122] = true,  -- Priest - Psychic Scream
			[ 87204] = true,  -- Priest - Sin and Punishment (131556?) (Vampiric Touch Dispel)
			[  2094] = true,  -- Rogue - Blind
			[  5246] = true,  -- Warrior - Intimidating Shout
			[  5782] = true,  -- Warlock - Fear
			[118699] = true,  -- Warlock - Fear (new)
			[  5484] = true,  -- Warlock - Howl of Terror
			[115268] = true,  -- Warlock - Mesmerize (Shivarra)
			[  6358] = true,  -- Warlock - Seduction (Succubus)
		},
		stun = {
			[108194] = true,  -- Death Knight - Asphyxiate
			[221562] = true,  -- Death Knight - Asphyxiate?
			[ 91800] = true,  -- Death Knight - Gnaw
			[179057] = true,  -- Demon Hunter - Chaos Nova
			[211881] = true,  -- Demon Hunter - Fel Eruption
			[205630] = true,  -- Demon Hunter - Illidan's Grasp
			[203123] = true,  -- Druid - Maim
			[  5211] = true,  -- Druid - Mighty Bash
			[163505] = true,  -- Druid - Rake
			[117526] = true,  -- Hunter - Binding Shot
			[ 24394] = true,  -- Hunter - Intimidation (Pet)
			[117418] = true,  -- Monk - Fists of Fury
			[119381] = true,  -- Monk - Leg Sweep
			[   853] = true,  -- Paladin - Hammer of Justice
			[200200] = true,  -- Priest - Holy Word: Chastise
			[226943] = true,  -- Priest - Mind Bomb
			[199804] = true,  -- Rogue - Between the Eyes
			[  1833] = true,  -- Rogue - Cheap Shot 
			[   408] = true,  -- Rogue - Kidney Shot
			[204399] = true,  -- Shaman - Earthfury (no DR?)
			[118905] = true,  -- Shaman - Static Charge (Capacitor Totem)
			[ 89766] = true,  -- Warlock - Axe Toss (Felguard)
			[ 22703] = true,  -- Warlock - Infernal Awakening (Infernal)
			[ 30283] = true,  -- Warlock - Shadowfury
			[132168] = true,  -- Warrior - Shockwave
			[132169] = true,  -- Warrior - Storm Bolt
			
			[ 20549] = true,  -- Tauren - War Stomp
		},
	},
	harm = {},
	help = {},
	zone = {
		[64373] = true -- Armistice (Argent Tournament Zone Buff)
	}
}

-- merge CC categories to allow aura.cc[spellId]
do
	-- an extra step to avoid modifying the table while iterating
	local categories = {}
	for name,_ in pairs(auras.cc) do
		categories[#categories+1] = name
	end
	
	for i=1,#categories do
		for spellId,_ in pairs(auras.cc[categories[i]]) do
			auras.cc[spellId] = true
		end
	end
end

Engine:NewStaticConfig("Data: Auras", auras)