# DiabolicUI Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) 
and this project adheres to [Semantic Versioning](http://semver.org/).

## [1.3.97] 2017-02-04
### Changed
- Rewrote a lot of the tracker's update cycle to avoid flickering, disappearances and so on.
- Rewrote most of the tracker's internal anchoring, to avoid the weird indendted "tree" view that some users were experiencing. 
- Added in an extra set of updates for the tracker's quest item buttons, to avoid them getting the wrong ID and becoming unusable after a while. More might be needed, I will monitor the situation closely on my alts!

## [1.3.96] 2017-02-02
### Changed
- Added new colors for NPCs you have a Honored or higher standing with. From Honored to Exalted the colors move slightly towards cyan.
- Added the same new colors for Friendship standings from Friend to Best Friend as was used for Honored to Exalted reputation standings.
- NPCs that are friendly or neutral to the player now have their nameplates colored in the same color as their unitframes.
- Completed Quests are now displayed in the objective tracker regardless of current map zone.

### Fixed 
- Fixed a bug that would occur when scanning the item levels of crucible upgraded Artifact relics from the character window.

## [1.3.95] 2017-02-01
### Fixed
- Added a lot of items to the Minimap's icon whitelist, to allow elements from Gatherer and HandyNotes, Zygor Guides and several others to be shown.

## [1.3.94] 2017-01-31
### Added
- Added new Order Hall follower tooltips to the list of styled tooltips. 

### Fixed
- Fixed an issue in Legion clients where the quest tracker's sorting function sometimes would cause an error while trying to figure out the closest one quest.

## [1.3.93] 2017-01-30
### Added
- Added secondary profession quests to the priority list visible in all zones in the quest tracker.

### Fixed
- Changed how the override action bar (vehicles) is hidden to avoid the old bar (though transparent) covering it and causing wrong clicks and tooltips.

## [1.3.92] 2017-01-28
### Fixed
- Added regular Guild Roster updates to keep the online guild member count on the bottom left corner social button properly updated. 

## [1.3.91] 2017-01-27
### Fixed
- Fixed an annoying nil bug in the new Battleground Score module that would fire whenever a timer was visible. Oops!

## [1.3.90] 2017-01-27
### Added
- Battleground scores, dungeon waves and similar has been added! Visible at the top of the screen, hidden when a target is selected to keep the UI clean. Not movable. Not optional. 

### Changed
- Changed how the unitframes in some places decided whether or not a unit was friendly to decide bar coloring. This was just a visual change to fix the issue with the NPC nameplates sometimes being differently colored from the unitframes. 

### Fixed
- Empty actionbuttons in Cata and WotLK clients will no longer have their checked, empty and highlight textures visible all at once until hovered over.
- Trying to work around a Blizzard XP bar text issue causing a nil bug for Starter Edition characters at level 20 when the UI is reloaded.

## [1.3.89] 2017-01-25
### Fixed
- Fixed a tooltip-related actionbar bug in clients prior to Legion.

## [1.3.88] 2017-01-25
### Changed
- Improved the money display in the bottom left corner slightly. 

### Fixed
- The UI should once again work for WotLK and Cata, as incompabilities in the tracker and social button modules have been sorted out.

## [1.3.87] 2017-01-21
### Added
- Added Mac'Aree, Antoran Wastes, Krokuun and Argus as Legion zones to the tracker. World Quests should be visible while in Argus now. 

### Changed
- Trying some experimental changes to show Highmountain World Quests while inside Thunder Totem. 

## [1.3.86] 2017-01-21
### Changed
- Changed how the social button in the bottom left corner displays online Guild Members. It should be updated on first login now. 

## [1.3.85] 2017-01-20
### Added
- The Friends & Guild menubutton in the bottom left corner of the screen will now show online guild members and friends in the tooltip, as well as showing a count for total number of online friends and guild members (yourself excluded) on the button itself.
- Added your current money in gold/silver/copper beneath the chat/social menu buttons in the bottom left corner of the screen.

### Changed
- The chat bubble module will now hide its bubbles if the bubble message is nil or empty. This is to allow other addons and modules to filter or hide the DiabolicUI bubbles by modifying the text in the original blizzard bubble. 

## [1.3.84] 2017-01-20
### Added
- The stance bar toggle button should now cancel any non-normal stance or form when right-clicked, while keeping it's normal toggle behavior when left-clicked as before. The tooltip updates dynamically to reflect whether or not there are any active forms or stances to cancel.
- Added a twitter link to the GitHub README file.

### Removed
- Removed the fix for the "Not enough players" spam on the Felsong realm, as this has been moved to a separate addon specifically targeting Felsong bugs and annoyances. Get it at https://github.com/cogwerkz/Felsong_Companion

## [1.3.83] 2017-01-19
### Added
- The WorldMap's map textures are now slightly toned down and colorized to allow the overlay objective icons to stand more out. 
- The QueueStatusButton's tooltip in Legion should now be styled similarly to the rest of the UI.

## [1.3.82] 2017-01-18
### Changed
- The DiabolicUI nameplates now also disable themselves if the addon TidyPlates_ThreatPlates is loaded.

## [1.3.81] 2017-01-17
### Changed
- Changed the quest sorting in the custom tracker. Primary Profession Quests in the current map zone will now appear at the top of the list, followed by any normal quests in the current map zone, followed by any World Quests in the current map zone, and finally Emissary and Elite World Quests in the current map zone. The philosophy behind this is that quests you have specifically picked up should have a higher visual priority than repeatable World Quests. Super tracking is not yet affected by this new filtering, but it will be updated in the near future.

## [1.3.80] 2017-01-17
### Fixed
- Added updated Legion 7.3.5 Minimap Blip Textures. All the icons inside the Minimap like quest givers, vendors, mailbox and so on should work again now. 

## [1.3.79] 2017-01-15
### Changed
- More fixes to the GameTooltip to work around Blizzard's faulty Legion 7.3 nameplate protected tooltip bug.

## [1.3.78] 2017-01-10
### Changed
- No attempts should be made to show, hide or move the GameTooltip if it's become protected by Blizzard's faulty Legion 7.3 nameplates anymore.

## [1.3.77] 2017-01-07
### Added
- Added /rl /reload and /reloadui as ReloadUI() chat commands to all client versions.

### Changed
- Updated the zhCN localization.

## [1.3.76] 2017-12-19
### Changed
- Changed how the UI deals with the PlaySound changes in the 7.3.0 WoW client patch, to be compatible with the nitwit way Ace3 handles it. They check for the existence of the PlaySoundKitID API call and base their PlaySound usage on that, instead of checking for the client version as they should. 

## [1.3.75] 2017-12-09
- Working around the protected GameTooltip bug introduced with secure friendly dungeon nameplates in WoW patch 7.3.0 by Blizzard. This bug mostly occurred on specs with dispel abilities when hovering over friendly auras. 

## [1.3.74] 2017-12-05
### Fixed
- Fixed a missing pointer to the addon locales in the nameplate module, which sometimes would cause excessive error spam.

## [1.3.73] 2017-12-05
### Fixed
- Fixed an issue with the LevelUpDisplay on Cata realms that broke the UI. 

## [1.3.72] 2017-11-29
### Fixed
- Fixed an issue with the character frame's item level display, which would sometimes bug out with some weapon types.
- Fixed an issue with the character frame's item level display which would leave the background shade of the item level visible even when no item level was displayed.

## [1.3.71] 2017-11-04
### Fixed
- Fixed some color library bugs that caused the UI to break on all WoW clients below Legion.

## [1.3.70] 2017-09-27
### Fixed
- Fixed an issue where some Brewfest dailies would bug out the tracker. The tracker still does not display these quests, but at least it doesn't cause bugs and a big error frame in the middle of the screen anymore.  

## [1.3.69] 2017-09-26
### Added
- Added world quest rarity colors to our internal color database

### Fixed
- The tracker should now display a correctly rarity colored plus sign for elite world quests.

## [1.3.68] 2017-09-14
### Fixed
- Fixed an issue where the UI would attempt to load the Artifact bar in WoW clients older than Legion.

## [1.3.67] 2017-09-14
### Added
- Added a Legion honor points bar visible while inside a PvP instance.

### Changed
- Changed when the tracker gathers information about a quest's zone, to work around some major fps drops in certain conditions in Legion. 
- Renamed the internal Engine API call 'GetStaticConfig' to 'GetDB' as this better reflected its purpose.

### Fixed
- Fixed an issue that would cause limited starter edition accounts playing at full level on the PTR to not get their Artifact Power displayed as a bar. 
- Fixed an internal issue that would give quality colors the wrong index in our custom color table. This issue never affected the player, and was merely a backend fix.

## [1.3.66] 2017-09-09
### Changed
- In Legion Blizzard decided to unload all hidden UI textures from memory. This causes constant disk access and flickering. In an effort to work against this I've changed how textures are displayed in the GameMenu and on the actionbutton styling functions from showing and hiding to changing the opacity instead. This keeps the textures in memory and removes the annoying flickering. The textures use a few kilobytes of ram each, the whole UI a few megabytes, while the game uses several gigabytes. Unloading 2D textures from memory is absolutely idiotic, and does nothing but increase disk access, cause flickering and lag spikes. Good one, Blizzard. 

## [1.3.65] 2017-09-07
### Changed
- Rares and elites should get the same target frame artwork as bosses now. Will make separate artwork for rares and elites later, just wanted them to stand more out for the time being. 

### Fixed
- Fixed some issues related to the 12-hour clock. Not that the 12-hour clock has been available as a user choice yet, but still... fixed.

## [1.3.64] 2017-09-04
### Changed
- Upgraded itemlevel display in character frame and blizzard bags to perform an extra check for upgraded items.
- Micro menu buttons in the bottom right corner of the screen that are disabled will now appear darker in color instead of being transparent, as this looked really weird when Bagnon was open and its icons and numbers shone through. 

### Fixed
- Resetting chat settings through the blizzard options menu shouldn't bug out anymore.

## [1.3.63] 2017-09-01
### Fixed
- Minimap buttons collected by the addon MinimapButtonBag(MBB) should now properly appear at a higher framelevel than the Minimap, and not underneath it where they where unclickable. 

## [1.3.62] 2017-08-30
### Fixed
- Added WoW 7.3.0-compatible Minimap blip icons. Blizzard keeps rearranging them on every major and minor patches, so it's probably an autogenerated thing. Should remember to check this for every new content patch from now on.

## [1.3.61] 2017-08-29
### Changed
- Bumped the toc version to patch 7.3.0.

## [1.3.60] 2017-08-26
### Added
- New round Minimap.
- Legion Nameplates now have a large crowd control icon displayed above themselves!
- Added in proper seamless MBB(MinimapButtonBag) support. 
- Added in some minor styling of the character frame, talent frame, group finder frame, spellbook, worldmap and containers. 
- Added in itemlevel display to the character frame and container frame.
- Added some performance tweaks to prevent other addons misusing or overusing garbage collection and memory usage queries. 

### Changed
- The Minimap module will disable itself if the addons Mappy or SexyMap are enabled.
- The UI should no longer enforce no rotation on the Minimap, since the new round one easily can be rotated.
- The Minimap will no longer forcefully change the WorldMap to the current zone when moving between zones when the WorldMap is open. It will instead hide the player coordinates until the WorldMap is closed, and then resume the updates. This will not prevent other third party addons from calling commands that forcefully change the WorldMap zone, though.
- Minimap buttons will now be hidden unless the addon MBB(MinimapButtonBag) is installed and enabled. A built-in button bag for Minimap buttons will be added at a later date, but for now we're letting MBB handle this. It's good at it. 
- Changed the layout of the quest tracker to match the new Minimap, and moved usable quest items to the left side of it instead.
- Legion nameplates had their maximum visible distance adjusted to 45 yards while inside an instance, and 30 yards while not.
- Auras displayed in the new Legion nameplate CC display will not be displayed amongst the normal auras below the nameplate.
- Auras displayed anywhere on the Legion nameplates should not be visible on the target unitframe if a nameplate is currently visible for your target. This is a work in progress.
- Changed how auras are displayed on the target frame. A lot of new filters were added, and the old ones optimized. This is a work in progress, and in no way finished. 
- Toned down the new item flash texture in the default Blizzard bags for client versions supporting this. It was just too much.
- The player castbar will now be disabled if the addon Quartz is enabled.
- Seriously optimized the performance of the quest tracker. Pimped that Lada of a module into a Lamborghini Sesto Elemento!
- Optimized the Blizzard vehicleseat, durability, ghostframe and player alt power modules to better utilize the Engine methods and systems.
- Prefixed most modules that only slightly modified the look of Blizzard elements with "Blizzard: " in order to reflect their nature better. Most of this UI is custom and built from scratch, but some elements can't be changed, or isn't practical or compatible to change. These modules should now be easier to identify in the code. 

### Fixed
- Fixed a tracker issue in WoW clients Cata or higher where quest item buttons would get the wrong quest log index assigned, and either end up being unusable or use the wrong item. 
- Fixed a tracker issue in WotLK where the tracker sometimes wouldn't start an no quests were displayed at all.
- Fixed an issue with the micro menu (mostly) in WotLK that would cause taint on every combat ending as a result of a micro button update wrongfully being called upon UnitAffectingCombat("player") returning false instead of InCombatLockdown(). (UnitAffectingCombat returns false until an attack has landed when proximity aggroing creatures, and thus is unreliable when it comes to figuring out if it's safe to move or change protected items, as these are forbidden as long as we're engaged in combat in any shape or form.)
- Fixed a tracker issue where item cooldowns didn't show up.
- Fixed an issue with the tracker's world quest proximity filtering which would assume all zones were perfect squares, and thus end up sorting world quests in a consistent but totally wrong ord. We could go by the aspect ratio of the WorldMapDetailFrame, but choosing to use the Legion API call C_TaskQuest.GetDistanceSqToQuest(questID) instead, since we're only tracking proximity of Legion world quests anyway. 

### Removed
- Removed the ability to manually track quests from the Blizzard (WoD and Legion) QuestLog, as our quest tracker overrides this anyway. The ability to manually track specific quests will be added into our own tracker at a later date. For now, though, it was more important to remove useless remnants of non existing functionality to avoid confusion. 

## [1.2.59] 2017-07-29
### Changed
- Reduced the maximum visible Legion nameplate distance from 100yd to 30yd, as nameplates of mobs outside buildings were visible through the walls and floors, causing major confusion when trying to target something. An example was when killing Captain Volo'ren in Val'Sharah. 

## [1.2.58] 2017-07-26
### Fixed
- Already visible chat bubbles will now be hidden upon entering an instance, instead of remaing visible on the screen.

## [1.2.57] 2017-07-24
### Added
- Added back most of the Blizzard alert frames, except some too spammy loot and currency alerts. Also moved the alert frames slightly higher up on the screen. Note that this is a temporary solution, and custom alerts will be added at a later point. The Blizzard alerts can easily grow too much upwards and prevent us from clicking players and NPCs in the game world, and we simply need a better system than that. 

## [1.2.56] 2017-07-24
### Changed
- Added TinyTip and TinyTooltip to the tooltip incompatibility list. This means that when one of these addons are loaded, they'll handle the tooltip, and not DiabolicUI.

## [1.2.55] 2017-07-24
### Changed
- The tooltip modules will now disable themselves if TipTac is loaded.

## [1.2.54] 2017-07-23
### Changed
- The nameplate module will now disable itself if the addon Kui_Nameplates is enabled. 

### Removed
- Removed all Blizzard alert frames. They were excessive, unnecessary, and in the way. 

## [1.2.53] 2017-07-23
### Fixed
- Worked around the Blizzard bug causing /framestack to bug out with frames that are numbered indices of their parents by removing all such frame references from the UI. Previously the unitframe and nameplate aura modules used this, but both are now using hashed keys instead. This fix of course only applies to this UI, and there is no way to prevent other addons from causing the same /framestack bug.  

### Removed
- Removed auras from the Legion Personal Resource Display (the player nameplate). 

## [1.2.52] 2017-07-22
### Added
- Added castbars to Legion nameplates. Protected casts are glowing, regular ones are not. 
- Added auras to Legion nameplates. Differs slightly from the Blizzard plate auras, as we amongst other things are showing HoTs and shields also. Will expand on the filtering later.

### Changed
- Enemy NPC nameplates in Legion (unless tap denied) should now get their entire health bar colored in a color reflecting your current threat situation with them. In other words, yellow mobs will turn red when you attack them solo.
- Elevated the framelevel of Legion rare- and boss nameplates to right below that of the target nameplate, in order to make them easier to see while standing in a swarm of other players trying to tag the same rare elite before it's dead. This change doesn't affect the actual clickable framelevel of the actual secure unitframe, it only affects the visual part. The intention is to make it an easier task to see where the rare actually is, and not waste time looking instead of clicking.
- Optimized the Legion nameplate code more.

## [1.2.51] 2017-07-20
### Changed
- Reduced all nameplate update cycles to 1/30 of a second.

### Fixed
- Fixed a bug in the nameplate update cycle that could cause nameplates to instantly fade out instead of in.

## [1.2.50] 2017-07-19
### Added 
- Added a Lunar Power color for the orbs. We didn't have one. 

### Changed
- Reduced the action button range checker update frequency to 1/5 of a second, down from 1/20 of a second to gain some performance. 
- Reduced the nameplate health update frequency from 1/120 to 1/60 of a second. 
- Reduced the nameplate opacity update frequency from 1/120 to 1/30 of a second. 
- Removed flight coloring from the actionbuttons, as this was unreliable anyway. This applies to taxis and normal flight. 
- Made the angry red NPC color a lot angrier and more red, to stand out more from other mobs and from Death Knights.
- Made the Death Knight color slightly more tilted towards blue to stand out more from angry mobs, even though most Death Knight in truth are fairly angry people too.
- Made the Hunter color slightly brighter, to stand out more from NPCs. 
- Made the friendly player color green, same as friendly NPCs which is easier to separate from hostile players than the blue which either would look like Mage blue or Shaman blue. Also chose to NOT use the same purple as the default Blizzard nameplates, as this just makes everybody look like Warlocks. 

## [1.2.49] 2017-07-18
### Added
- Added the PlaySoundKitID() API call to WoW client versions prior to Cata, to keep the coding consist between client versions. 
- Added back the Blizzard cooldown numbers to the actionbuttons for WoD clients and higher.
- Added back the Blizzard interface option to show cooldown numbers on the actionbars for WoD clients and higher. 

### Changed
- Changed how cooldowns are displayed on the action buttons. Should be more similar to the default Blizzard UI now, and easier to understand. 
- Changed how removed Blizzard interface options were shrunk down, as they would sometimes leave a huge empty space in the interface menu.

### Fixed
- Fixed an issue where buttons on the action bar that had their spell changed after a cast wouldn't update their icons properly. 
- Fixed how charges were displayed on the action buttons, as this would sometimes be wrong.
- Fixed an issue in WotLK clients where the PlaySoundKitID API call would cause a nil error as it technically didn't exist until Cata. 

## [1.2.48] 2017-07-17
### Fixed
- Fixed a bug with the zone ability buttons that would make the cooldown spiral fill the entire screen. 
- Fixed an issue that would keep available spell charges hidden from the actionbuttons. 

## [1.2.47] 2017-07-15
### Changed
- Added the combat resource tracking addon Engraved as a recommended addon in the README file.

### Fixed
- Fixed a bug that prevent auras from being shown on the target frame.

## [1.2.46] 2017-07-13
### Changed
- Some code cleanup.
- Added the "Already looted" error message to a new blacklist in the objective module's warnings element. This is mainly a workaround for a known bug on TrinityCore based realms.

### Fixed
- Added in some extra event checks to fix an issue where new quest items needed the world map to be toggled before working properly in our tracker.
- Fixed an issue that could cause both completed objectives and the completed quest message to be visible and overlapping in the tracker.

## [1.2.45] 2017-07-11
### Fixed
- Fixed an issue with the tracker that would sometimes cause objectives to have overlapping (and wrong) messages displayed.

## [1.2.44] 2017-07-11
### Added
- Added back the PlaySoundKitID() API call to WoW client versions 7.3.0 and higher, as Blizzard decided to remove it and have the regular PlaySound() use soundkitIDs as input argument instead. We want consistency.

### Changed
- Changed all the PlaySound() calls to use PlaySoundKitID() instead.
- Actionbuttons should now all be grayed out when the player is dead, similar to when the player is using a taxi.

### Fixed
- Fixed bugs related to when CompactPartyFrames spawn in Legion clients, which was causing bugs and lag in small groups.

## [1.2.43] 2017-07-10
### Changed
- Removed the blizzard tracking of world quests from our own tracker, as it was producing lag and freezes for some people. It's not needed for us to either track the quest or have it's area and objectives visible on the Minimap. 
- Player debuff display above the actionbars should now track stackable auras with not timer, like Death Knight's Decomposing Aura. 
- Some minor optimizations to the texture display of the target unit frame.

## [1.2.42] 2017-07-09
### Changed
- Tracker is hidden and suspended within instances for the time being. Will re-activate later, and add boss kill tracking, mythic timers and more. 
- Minor optimizations to how the tracker shows, hides and updates its quest objectives.

### Fixed
- Attempted to disable more of the default Blizzard objectives tracker functionality to avoid some mythic instance bugs. Untested. 
- Fixed a nil bug which would occur in the tracker when changing zones or changing visible world map zone.

## [1.2.41] 2017-07-09
### Changed
- Don't supertrack Emissary quests, as they have no general direction to head in except their zone, which we're probably already in.

### Fixed
- Rearranged levels of breath timer textures, as the bar accidentally ended up behind the backdrop texture.

## [1.2.40] 2017-07-09
### Fixed
- Fixed a tracker bug on WotLK clients, as quests can only be super tracked on Cata clients or higher.
- Fixed a tracker nil bug occurring for some Legion World Quests as they sometimes have hidden, empty objectives. Weird. 
- Redid the fracking tracker sorting function again. Am I getting better or worse? 

## [1.2.39] 2017-07-08
### Added
- Added support for the addon WorldQuestGroupFinder's middle click functionality to the objective tracker's quest titles.
- Added a PvP emote module that'll hug and do various other things to dead enemy players for achievements and fun.

### Changed
- Changed layer order for battleground opening countdown timers, as the spark sometimes would appear behind the bar texture.
- Changed the custom tracker sorting function in an attempt to have it comply with the strict rules for sorting nested tables and get rid of the "Invalid order function for sorting" bug. Hard issue to fix. Fix not guaranteed.
- Moved custom realm compatibility and fixes into the core folder and made the file standalone.

## [1.2.38] 2017-07-07
### Changed
- Trying a slightly brigher mana orb color for Druids and Monks, to make it fit better with their other resources. 

### Fixed
- Fixed an issue where quest items wouldn't be shown in the objectives tracker, and instead return an error. Weird as it may seem, I missed this error since I developed the whole thing on a top level character with no quests with usable quest items in them, and thus only discovered this minor oversight when returning to level a low level alternate character. Sorry! :o

## [1.2.37] 2017-07-07
### Fixed
- The custom objectives tracker sorting function now specifically returns true/false values, and no nil values as these would cause and "invalid sorting function" lua error. Coding for dummies. 

## [1.2.36] 2017-07-07
### Fixed
- Added an existance check to the custom objectives tracker sorting function, since it for some reason only receives one element now and then.

## [1.2.35] 2017-07-07
### Added
- Added GitHub templates for issue reports, repository contributors and pull requests. Thanks Kkthnx! :)

### Changed
- Quest super tracking should now for the most parts follow the top entry of the custom objectives tracker. Applies to Cataclysm clients and higher.
- Completed quests in the objectives tracker are now placed at the bottom of the tracker, and had their opacity slightly toned down. 
- Elite Legion world quests in the objectives tracker are now placed right before the completed quests at the bottom.
- Legion Emissary quests don't display their redundant level requirement in the objectives tracker anymore, as they're only visible and accessible at the proper level anyway.

### Fixed
- Added a fix for the excessive "Not enough players" chat spam in battlegrounds on the Felsong Legion realm.

## [1.2.34] 2017-07-06
### Fixed
- Attempted to bypass some errors in the objectives tracker by temporarily ignoring invasion quests. Will add them back in when the issue is sorted.  

## [1.2.33] 2017-07-06
### Added
- Added PvP Capture Bars. Tested in both outdoors PvP and all battlegrounds that have them.
- Added a Legion Artifact bar that replaces the XP bar for level 110 players. 
- Added new internal methods to allow modules to register themselves as incompatible with other addons, to simplify my process of automatically disabling a module based on whether or not the given addons are installed and marked as enabled in the addon listing. 

### Changed
- The pet actionbar have been repositioned above the standard actionbars.
- The pet actionbar has a temporary (but viable) placeholder backdrop that will be replaced by a custom one later on.
- Side actionbars have changed layout and position, and are now located next to the angel- and demon statues. 
- Side actionbars now hides the grid/backdrop of empty buttons, to look less cluttered on-screen.
- The backdrops/grids of empty buttons on the side bar and the pet bar will now also become visible when holding the Alt+Ctrl+Shift modifier combination down. This is the same combination that allows you to drag/remove spells and abilities from your action buttons. 
- The actionbars and actionbuttons now have their own handlers, available to all modules.
- Actionbutton keybind locales have been moved away from the action button handler and into the global locale files. 
- Created a unified system for "floating" actionbuttons like the ExtraActionButton, Draenor and Legion zone abilities, our StanceBar togglebutton, Vehicle and Taxi exit buttons, and probably several more to come in the future. The idea is to have all of these handled by a single template, and put into a single smart bar. Clean up the mess! I'm planning to add a Fishing Button like the one in Goldpaw's UI into this system. :)
- Started the work separating secure actionbar drivers into a more hidden backend, and artwork callbacks into a more user oriented space.
- Started the work rewriting the many artwork updates in the UI, with a more unified future artwork callback system in mind.
- Changed how debuffs are tracked on enemy frames. Only debuffs actually cast by the player should be shown now, and not debuffs the player has the ability to cast as previously, which led to damage buffs from other people of the same class being shown also. Note that a fully custom filter list is planned, as neither of these solutions are optimal. An example would be when we wish to apply our own DoTs, but may not wish to apply damage modifiers already present on the target, as this would waste our own resources and lower the overall group DPS. TO BE CONTINUED!
- Toned down the opacity of friendly NPC nameplates, to better focus players and hostiles. Planning to expand on this system later on to make it more intelligent and adjust itself based on the current situation, meaning if we're solo, in a PvP instance, a PvE instance, and so on.
- The nameplate module now disables itself if TidyPlates is enabled. The new auto-disable system mentioned in this update's additions was used. 
- The Blizzard TalkingHeadFrame has been moved farther up the screen, not overlapping the actionbars anymore. I chose to keep the talking head frame in the UI, even though it contradicts my design vision of less spam. In Legion the talking head can be really helpful when entering a world quest area. Plus, WoW-Freaks is using it for their own in-game announcements, so better keep it around for that. :) 

### Fixed
- Fixed a bug that would sometime cause Blizzard tooltips to be styled twice, and get multiple health values layered on top of each other.
- Fixed an issue with vehicles that would sometimes result in an empty, hidden health orb.
- Fixed an issue where the XP/Artifact bar would hover in mid-air while entering a vehicle, while the rest of the bars changed to vehicle layout. The XP/Artifact bar now instantly disappears upon starting the entering process, along with all the other unitframe and actionbar changes.
- Fixed a bug that would cause a player ability from the main actionbar to picked up when trying to pick up a pet ability from the pet bar.
- Fixed an issue in MoP clients and above that would leave the Blizzard background texture on the Group Finder Minimap button.
- Fixed an issue in clients older than Legion where actionbuttons wouldn't be unsaturated while flying or using a taxi at login or reload.
- Fixed the issue with the chat bubble module causing walls of errors when scanning the WorldFrame while being inside instances in Legion 7.2.0-7.2.5 (and beyond) by forcefully disabling turning off chat bubbles inside instances and stopping the chat bubble scanner. 

### Removed
- Completely disabled the Blizzard LevelUp display for all WoW client versions that had it. Enough with the on-screen spam. Too much is happening in WoW for all this arcade wannabe in-your-face explosive announcement shit to work. We will however add in our own BETTER system for this later on, and that system will function in all WoW client versions thus giving a more unified experience across expansions. 
- Removed the DropDownList framelevel bug fix, as it was producing a "script ran too long" error.

## [1.1.32] 2017-03-06
### Changed
- Minimap coordinates should now be hidden when the WorldMap is visible and set to another zone than the current.

### Fixed 
- Spell Activation Overlay Glows should fire more correctly now.

## [1.1.31] 2017-03-01
### Changed
- Quests in some instanced starter zones like the Death Knight one will now automatically be tracked, even though they don't always carry a valid mapID. 

## [1.1.30] 2017-03-01
### Changed
- Toggled the player debuff display to only filter away debuffs with a total duration above 5 minutes while currently engaged in combat. 
- Whitelisted some important player debuffs to always be shown, like Fatigue, Sated, Insanity, Exhaustion and Resurrection Sickness. 
- Cooldown numbers on the aura buttons and action bars are now hidden by default. Custom ones will be added later. 

### Fixed
- Fixed a bug that would leave the backdrop of the XP bar visible while using a vehicleUI.
- Fixed a bug that would cause the display of itembuttons in the quest tracker to fail.

## [1.1.29] 2017-03-01
### Changed
- Pixel borders on unfinished quest objectives as well as unitframe aura borders now rescale when resolution, display size or UI scale changes. Will still return faulty sizes if the game window have been manually resized to a size not matching the chosen resolution, though. The same applies to if the user maximizes the window while a different resolution is chosen than the actual one. We simply can't retrieve the actual window size in these case from within the addon API. 
- Worked some more on stream lining the custom quest tracker text alignment.

### Fixed
- Fixed a bug where the top left corner of the completion text in the quest tracker was anchored to the bottom center of the quest title instead of the bottom left. Ouch.

## [1.1.28] 2017-02-27 
### Changed
- Moved the bag bar to the left side of the bag button, from its old position above it, as it was colliding with the bags. 
- Wrote a new text parser for the objective's tracker to better decide number of lines and words per line for all text entries.

### Fixed
- Fixed a bug with the tooltip module that occurred while holding shift and hovering over auras with no available caster unitID.
- Fixed an alignment bug in the custom quest tracker in Legion related to some fontstrings not having a default size, as required in Legion. 
- Fixed a bug with the custom tracker that would open empty windows instead of the correct quest log entry when clicking on quest titles.

## [1.1.27] 2017-02-23
### Added
- Hovering over the time display above the Minimap will now show a tooltip with both local and realm time.
- Left-Clicking the time display above the Minimap will now show the in-game event calendar!
- Added the various mirror timer colors (breath, fatigue, etc) to the UIs internal color table.

### Changed
- The custom StatusBar handler now calculates sizes based on points before stored size, leading to less weird bugs and strange results.
- Changed how the UnitFrame handler's Aura element stores and displays things, to reduce incompatibilities with other buff styling addons.
- Did a lot of general code optimizations.

### Removed
- Removed the old combo point system altogether, even for Druids. The upcoming new resource point system will replace it.

## [1.1.26] 2017-02-22
### Added
- Slightly styled the /fstack and /eventtrace frames, mainly because I use them a lot and wanted a look that fit the UI.

### Changed
- The Player NamePlate now has support for the WeakAuras personal resource display attachments by pretending to be a KUINamePlate. 
- The Target UnitFrame is now limited to only showing debuffs from the player and bosses. Buff filtering remains unchanged. I'm also working on a better filter. 

### Fixed
- Worked around a blizzard bug that would cause frames with no name or hashed reference to break the /fstack. 
- Fixed a bug that would prevent friendly auras to be removed by right-clicking, even when out of combat. 
- Fixed a startup bug in WotLK clients that would cause the PLAYER\_ENTERING\_WORLD event to be skipped.
- Fixed the issue where NamePlates wouldn't be initialized on the first character login in WotLK, was a result of the above problem.

## [1.1.25] 2017-02-21
### Changed
- The custom DiabolicUI font objects will now change to region specific versions of the Google Noto font for zhCN, zhTW and koKR realms.

## [1.1.24] 2017-02-21
### Changed
- The default scaling of DiabolicUI will now better fit most screen resolutions.
- The target NamePlate (Legion only) will now be kept below the target unitframe and above the bottom actionbars.
- Mirror timers (breath, fatigue, etc) now has a dark background and a spark, and looks more like the castbars and unitframes.

## [1.1.23b] 2017-02-20
### Changed
- Temporarily disabled the combo point display for Rogues in MoP and above, since this turned out to be bugged.

## [1.1.23] 2017-02-20
### Fixed
- Fixed a bug in the QuestTracker that would lock the WorldMapFrame to the current zone 

## [1.1.22] 2017-02-19
### Added
- Added Noto fonts for zhCN, zhTW and koKR regions. 
- Added a custom and for the time being completely automatic quest tracker. No support for achievements yet, but it's coming!
- Added a new large, square semi-transparent Minimap in true Diablo III style.
- Added text based LFG/PvP/GroupFinder elements to the Minimap.
- Added information about group/solo status, dungeon size or territory PvP status (Contested, Alliance, Horde, Sanctuary etc) to the Minimap.
- Added information about a player's average item level, gear and specialization to the tooltip when holding down the Shift key.
- Added NamePlates. They currently only displays health and level, but more will be added.
- Added buffs and debuffs to the Target frame.
- Added Player buffs and debuffs, placed above the action bars. 
- Added health values to the unit tooltip health bar.
- Added spell name and cast timer to the Target cast bar.
- Added cast timer to the Player cast bar.
- Added subtle background shades to the target, tot, focus and pet unitframes, to make them easier to see on both light and dark backgrounds.
- Added subtle background shades to the player castbar and also the warning and objective texts to make them too stand more out when visible. 
- Added UI sounds when clicking the chat- and menu buttons in the corners.
- Added UI sounds when showing or hiding action bars.
- Added UI sounds when targeting something and canceling your target. 
- Added more methods to our custom Orb- and StatusBar UI widgets.

### Changed
- Health values are visible at all times on the Target Frame now, making it far easier to decide what kind of mob or opponent you are currently facing.
- Health and power values above the Player orbs are now both visible in combat and on mouseover, so you more easily can track your own resources. 
- Added a descriptive text (Health, Rage, Mana, etc) to the Player orbs which will be visible on mouseover. 
- Power bars on the target frame will now remain visible even when empty if the target is a player.
- Red warnings and yellow quest objective updates are now displayed more centered, closer to the character. 
- Minimap rotation is now forcefully turned off, as rotation is incompatible with a square Minimap.
- The Game Menu (Esc) centers itself vertically upon display now (if out of combat), making it centered regardless of number of buttons or game client version.
- The player health orb is now colored by your current character class.
- The player power orb is now split in two for classes and specs that currently have mana in addition to another primary resource.
- Changed, corrected and upgraded a lot of the class- and power colors, both the single bar colors and the multi layered orb colors. 
- Changed the git folder structure to treat the root folder as the main addon folder. 
- Changed from the DejaVu font family to Noto, as Noto has variations with support for all WoW's client locales.
- Split the static module setups and default user settings into separate folders, to make the addon easier to understand for other developers and enthusiasts. 
- Did a lot of performance tweaks both to the core engine and the modules.

### Fixed
- Fixed a bug where the chat bubbles sometimes would bug out if other addons had added child frames to the WorldFrame.
- The XP bar now properly hides when entering player frame vehicles like the chairs at the Pilgrim's Bounty tables.
- Actionbuttons should now properly reflect if the target of the action is out of range.
- Actionbutton icons are now colored by priority: unusable > out of range > usable > not enough mana > unusable for other reasons.
- Fixed a bug in the core Engine that would prevent modules from getting ADDON_LOADED events.

### Removed
- Removed the old, round temporary Minimap that pretty much was just a slightly reskinned version of the Minimap from Goldpaw's UI. 
- Removed the Blizzard Order Hall bar (Legion). A custom one will be added later.
- Removed the Blizzard Objectives Tracker (Legion). Our own objective tracker replaces this. 
- Removed the Blizzard quest and achievement tracker (pre Legion). Our own objective tracker replaces this. 
- Removed the Blizzard player buff and debuff displays, as these now are replaced by our new aura display near the action bars. 
- Removed a lot of entries from the Blizzard Interface Options menu which either were replaced by our own, or made no sense in this UI.
- Removed the micro menu's shop button for game clients older than Legion, since they don't really have an in-game shop anyway. 
- Removed the micro menu's help button since it's available from the game menu in Legion, and a pointless button in older game clients. 

## [1.0.21] 2016-07-24
### Added
- Added zhTW locale by 公孟一文.

### Fixed
- Fixed number abbreviations on the XP bar for zhCN clients.

## [1.0.20] 2016-07-23
### Added
- Added zhCN entry for the stance button tooltip text.

### Changed
- Updated combo points for Rogues in Legion.

## [1.0.19] 2016-07-21
### Fixed
- Fixed some scaling issues in the custom popups.
- Fixed a problem related to figuring out the graphics resolution when UI scaling was enabled in Legion.

## [1.0.18] 2016-07-20
### Added
- Garrison Minimap button is back.
- Added the stance bar button's tooltip text to the enUS locale.
- Added better number abbreviations for zhCN clients.
- Added zhCN localization by 公孟一文.

### Fixed
- Fixed the mirrortimers and timertrackers. turns out blizzard had changed the names and keys of some of the textures.
- Fixed a tooltip bug when hovering over the stance button.
- Attempted to fix a bug that would occur when other addons used blizzard's TimerTracker system.
- Fixed a tooltip incompatibility with the addon SavedInstances.
- Fixed some problems with the locale handler that would prevent other locales than enUS from functioning.
- Fixed the "big bar in the middle of the screen" bug.
- Fixed an issue that would display a number instead of the red error messages on-screen.
- Fixed the zone ability button.

### Changed
- Bumped interface version to 7.0.3.

## [1.0.17] 2016-07-18
### Fixed
- Fixed a localization bug that would cause pre-Cata clients to malfunction if the UI scale was "incorrect".

## [1.0.16] 2016-07-17
### Added
- Added a popup to request whether or not you prefer to have the main chat window automatically sized and positioned.
- Added the chat commands "/diabolic autoscale", "/diabolic autoposition" and "/diabolic resetsetup".

## [1.0.15] 2016-07-16
### Changed
- Toned down the glare on the minimap overlay texture.
- Added frequent updates for unitframes whose unit didn't fire in events, such as ToT.

### Fixed
- Fixed a weird bug that sometimes would occur in the unitframe threat element.

### Removed
- Removed some debug output from the actionbar module that would show up at the start of pet battles
- Removed the annoying green paw texture that would appear on pet battle chat output frames

## [1.0.14] 2016-07-15
### Added
- Added stack size / spell charges to the actionbuttons.
- Added more updates to ToT unit names.

### Changed
- Moved the player's alternate power down, as it often was in the way of the target frame (for example when the blood moon event was active).

### Fixed
- Fixed action keybind in pet battles.

## [1.0.13] 2016-07-14
### Fixed
- Trying to work around a nil bug in the chat window module related to the chat icons. Unable to reproduce it so far, though.

## [1.0.12] 2016-07-13
### Added
- Added combopoints and anticipation.

### Changed
- Doubled the brightness of the threat texture.

### Removed
- Removed the autominimizing of the quest tracker in combat, as this was causing a taint if the user moved from one subzone to another while having quest objectives visible on the WorldMap and opening it. Now THAT took some time to figure out!

## [1.0.11] 2016-07-12
### Added
- Added threat coloring for all existing units with the exception of the player (that's coming later!).

### Changed
- Moved the durability frame, ghost release frame and vehicle seat indicators.
 
### Fixed
- Fixed issues that prevented new buttons in the stance bar from being clicked when learning new forms or changing talent specialization.
- Updated the Warrior action paging, which seems to have been wrong. New abilities will properly appear on the action bar after this change. 
- Fixed a typo that caused the UI not to load.


## [1.0.10] 2016-07-11
### Added
- Added some temporary statusbar texts for the targetframe and player orbs.

### Changed
- Restyled and repositioned the ExtraActionButton1 and the Draenor Zone ability button.

## [1.0.9] 2016-07-9
### Changed
- Stance (and other) buttons should now properly get a gold border to indicate when they are checked.

### Fixed
- Fixed an issue that would produce a bug if more than one mirrortimer (breath, fatigue, etc) was visible on-screen at once. Also adjusted the coloring to be darker and easier to see.

## [1.0.8] 2016-07-8
### Changed
- Moved the mirrortimer (breath, fatigue, feign death etc) slightly downwards, to make room for the upcoming targetframe auras.
- Moved the warning text ("You can't do that yet" etc) slightly down, to not be in the way of the mirror timer or the target frame.
- Slightly lowered the padding between the buttons on the side bars, pet bar and stance bar.

### Fixed
- Fixed a problem with the actionbutton overlay glows.

## [1.0.7] 2016-07-7
### Added
- Added a stance bar...'ish.

### Fixed
- Fixed a bug in the tracker module that would sometimes taint the worldmap's POI buttons if the worldmap was opened during combat. 
- Fixed a bug that would sometimes cause the focus frame powerbar to become stupid long instead of disappearing.

## [1.0.6] 2016-07-6
### Added
- Added MoveAnything's game menu button to our styled game menu. I highly recommend NOT using MoveAnything, though, as it causes taint and breaks UI and game functionality.

## [1.0.5] 2016-07-5
### Fixed
- Fixed an issue in Legion/WoD where the focus frame wouldn't reposition itself when the pet frame was shown.
- Fixed an issue in Legion where the castbar texture would be pure green, instead of light transparent white.

## [1.0.4] 2016-07-4
### Added
- Added ToT and Focus unitframes.

### Changed
- Chat should be visible for 15 seconds before fading, up from 5.

### Fixed
- Fixed some issues with the unitframe castbars where they sometime wouldn't update properly.
- Fixed a framelevel issue with the unitframe castbars that would render them above their border.
- Fixed a problem that sometimes would occur with female unitframe portraits.
- Fixed an issue where the chat window module would disable itself if Prat-3.0 was in the addon list, even if it wasn't enabled.

## [1.0.3] 2016-07-2
### Added
- Added a pet action bar.

### Changed
- Adjusted how the side bars resize and move themselves.
- Made the actionbar menu's backdrop darker, to make it less confusing when shown over an open quest tracker.
- All unitframe elements (like the portraits) should now be updated also when first shown.

### Fixed
- Fixed a bug that would make it impossible to dismiss or rename a pet through its unitframe after a /reload.

## [1.0.2] 2016-06-23
### Added
- Added the XP bar.
- Added some methods to the custom StatusBar object to accomodate the new XP bar.

### Changed
- Changed the shadow on the chat font to match the UIs general light direction.

### Fixed
- Removed some debugging output that would appear when clicking on the chat button with the mouse.


## [1.0.1] 2016-06-22
### Added
- The FriendsMicroButton is now forcefully hidden.

### Changed
- Updated the readme file.
- Chat module disabled if Prat-3.0 is loaded.
- Reverted the build number used to recognize the Legion expansion to a lower value.

### Fixed
- Fixed an issue where the chat button would sometimes become disabled after the input box was automatically hidden in classic style mode.
- The "canexitvehicle" macro option doesn't exist before MoP.
- Settings should now save properly between sessions for all clients.

### Removed
- Removed flash animations from chat bubbles, as this was causing client crashes for some users.

## [1.0.0] 2016-06-21
- Initial commit.
