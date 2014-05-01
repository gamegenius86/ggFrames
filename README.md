### ggFrames (v0.4.4)

ggFrames is a lightweight addon that replaces the default unit frames provided by Elder Scrolls Online.

**ggFrames currently replaces:**

  - Player Unit Frame
  - Group Unit Frames
  - Raid Unit Frames
  - Target Unit Frame

#### Installation Instructions

- Download Zip file (to the right)
- Move contents to `~/Documents/Elder Scrolls Online/live/Addons/ggFrames/`
- Restart game or run `/reloadui`

#### Features

- Player Unit Frame
  - Health
  - Magicka
  - Stamina
  - Experience: Very Slim / Unobtrusive
  - Mount Stamina: Only visible when mounted
- Group Unit Frames
  - *Name, Level, Class Icon, Group Leader Icon, Health Bar*
  - *Player frame will remain on top of group list, so that it will not confuse the player when grouped / ungrouped*
  - *Group member will fade out when no within support range*
- Large Group (Raid) Unit Frames
  - *Name, Group Leader Icon, Health Bar*
- Target Unit Frame
  - *Name, Level, Class Icon, Health Bar, and Caption*
  - *Reaction Colors* (Friendly, Hostile, Interactable, Default)
- All Frames Hide whenever in Menus (Backpack, Friends, Guild, etc)
- All Default Frames are Hidden
- Over 70 Customizable Settings
- Moveable Frames (/ggf or button in menu)
- Option to Disable Player Experience Bar. [Suggested By: Tonyleila]
- Font Styles
- Two Bar text display options ("current", "max", "percent", "current / max", "current / max (percentage)")
- Two Bar text location (Left, Right, Center)
- Option to Hide Players Info (Name, Level, Class) [Suggest By: pinstripesc]
- Combative Alpha [Suggested by Many]
- Bug Fix: Raid Frame Name / Status Positions
- Target Title & Captions
- Player Name Length: Issues with smaller frames
- All NPC Allys now appear "friendly" and Captions show appropriately

#### Coming Soon

- Disable Player Frame
- Hide Bars when talking to NPCs
- Moving Frames: Enter X & Y Coords
- Raid Frame Layout: 1x6 & 2x3
- ---
- Alliance Rank / Title
- Horse: Sometime the displays toggle state is backwards
- Level Textures (Use Veteran Texture and Create "Lvl" Texture)
- Target Unit Frame
  - *Bosses will appear slightly differently and give the user information such as its difficulty rating*
  - *Casting Bars with textual feedback telling you when to block, interupt, etc.* (If Possible)
- Shield Indicators
- Player Castbar
- Low Health Alert (flash when under xx%)
- Buff / Debuffs
- Target of Target Unit Frame(?)
- Reorder the Bars within Player Frame

#### Community Suggestions

- Bug: when moving frames the targets frame appears to be 1px lower than the frame when not hidden (http://i.imgur.com/hV6oTNN.jpg) [Reported by reddit user: Rhodsie47]
- Option to "Attach" Horse Stamina Bar to Unit Frame under Player Experience Bar. [Suggested By: Tonyleila]
- Option to Remove class icon and use class colors instead. [Suggested By: Tonyleila]
- Option to Hide Player [Suggested By: Fing3rz]
- Option to Change Master Transparency per frame [Suggested By: Fing3rz]
- Change opacity/color of the background of the bars. [Suggest By: curvne]
- Indicate Stats have increased regen rate, Like it made in default ui [Suggested By: SilverWF]
- Right Click your Frame: "Leave Group" [Willan]
- Right Click Party Members: "Kick Member" (if you're laeder), "Add / Remove Friend", "Invite To Guild(s)"? [Willan]
- Option to Unstack Players Health / Magicka / Stamina and instead display side by side [Suggest By: pinstripesc]

#### Feature Request?

Have a feature you want but dont see it listed above?  
Shoot me an email `gamegenius86@gmail.com` and let me know!

#### Found a Bug?

Shoot me an email `gamegenius86@gmail.com` and let me know!





===

https://gist.github.com/gamegenius86/11381484

ZO_UnitFrames:UnregisterForEvent(EVENT_RETICLE_TARGET_CHANGED)