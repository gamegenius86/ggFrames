GGF.UnitManager = {} 
GGF.UnitManager.unit = {}
GGF.UnitManager.unitRouter = {}

function GGF.UnitManager.Initialize()
  GGF.UnitManager.frames = {}
  GGF.UnitManager.Controls()
  GGF.UnitManager.frames.player:SetHidden(false)

  -- Create Unit Frames
  GGF.UnitManager.CreateUnit('Player', 'player', nil, GGF.UnitManager.frames.player)
  for i = 1, 3 do GGF.UnitManager.CreateUnit('Group'..i, nil, nil, GGF.UnitManager.frames.group) end
  for i = 1, 24 do GGF.UnitManager.CreateUnit('LargeGroup'..i, nil, "LargeGroupBase", GGF.UnitManager.frames.largeGroup) end
  GGF.UnitManager.CreateUnit('Target', 'reticleover', nil, GGF.UnitManager.frames.target)
  GGF.UnitManager.unit["Target"]:Unload()

  -- Initialize Group
  GGF.UnitManager.UpdateGroup()

  -- Register Events
  GGF.UnitManager.RegisterEvents()

  -- Ensure Player / Group Frames are Hidden
  ZO_PlayerAttributeHealth:SetHidden(true)
  ZO_PlayerAttributeMagicka:SetHidden(true)
  ZO_PlayerAttributeStamina:SetHidden(true)
  ZO_PlayerAttributeMountStamina:SetHidden(true)
  ZO_TargetUnitFramereticleover:SetHidden(true)
  ZO_UnitFramesGroups:SetHidden(true)
end

function GGF.UnitManager.CreateUnit(unitName, unitTag, baseTemplate, parent)
  GGF.UnitManager.unit[unitName] = GGF.Unit:New(unitName, baseTemplate, parent)
  if unitTag ~= nil then GGF.UnitManager.SetUnit(unitName, unitTag) end
end

function GGF.UnitManager.UnitFunction(unitTag, func, ... )
  if GGF.UnitManager.unitRouter[unitTag] == nil or GGF.move then return end
  for key, unitName in pairs(GGF.UnitManager.unitRouter[unitTag]) do
    GGF.UnitManager.unit[unitName][func](GGF.UnitManager.unit[unitName], ...)
  end
end

function GGF.UnitManager.SetUnit(unitName, unitTag)
  if GGF.UnitManager.unitRouter[unitTag] == nil then GGF.UnitManager.unitRouter[unitTag] = {} end
  table.insert(GGF.UnitManager.unitRouter[unitTag], unitName)
  GGF.UnitManager.unit[unitName]:Load(unitTag)
end

function GGF.UnitManager.UpdateGroup()
  if GGF.move then return end
  local unitRouter = {["player"] = {"Player"}, ["reticleover"] = {"Target"}}
  local groupSlot = 1
  local largeGroupSlot = 1
  for i = 1, 24 do
    unitRouter["group"..i] = {}
    if DoesUnitExist("group"..i) then
      if GetUnitName("group"..i) == GGF.UnitManager.unit['Player'].name then 
        table.insert(unitRouter["group"..i], "Player")
      elseif groupSlot < 4 then
        table.insert(unitRouter["group"..i], "Group"..groupSlot)
        GGF.UnitManager.unit["Group"..groupSlot]:Load("group"..i)
        groupSlot = groupSlot + 1
      end
      table.insert(unitRouter["group"..i], "LargeGroup"..largeGroupSlot)
      GGF.UnitManager.unit["LargeGroup"..largeGroupSlot]:Load("group"..i)
      largeGroupSlot = largeGroupSlot + 1
    else
      if GGF.UnitManager.unitRouter["group"..i] then
        for key, unitName in pairs(GGF.UnitManager.unitRouter["group"..i]) do
          if unitName ~= "Player" then GGF.UnitManager.unit[unitName]:Unload() end
        end
      end
    end
  end
  GGF.UnitManager.unit["Player"]:SetLeader(IsUnitGroupLeader("player"))
  
  -- Unload all unit slots after our last slot (this should NOT be necessary)
  for j = groupSlot, 3 do GGF.UnitManager.unit["Group"..j]:Unload() end
  for k = largeGroupSlot, 24 do GGF.UnitManager.unit["LargeGroup"..k]:Unload() end
  
  GGF.UnitManager.unitRouter = unitRouter
  GGF.UnitManager.groupSize = GetGroupSize()
  GGF.UnitManager.isLargeGroup = (GGF.UnitManager.groupSize > 4)
  GGF.UnitManager.frames.group:SetHidden( GGF.UnitManager.isLargeGroup )
  GGF.UnitManager.frames.largeGroup:SetHidden( not GGF.UnitManager.isLargeGroup )
end

function GGF.UnitManager.ToggleVisibility(isHidden)
  if GGF.move then return end
  GGF.UnitManager.frames.player:SetHidden(isHidden)
  GGF.UnitManager.frames.group:SetHidden(isHidden or GGF.UnitManager.isLargeGroup)
  GGF.UnitManager.frames.largeGroup:SetHidden(isHidden or not GGF.UnitManager.isLargeGroup)
end

function GGF.UnitManager.RefreshControls(section)
  if( section == nil or section == "Player" ) then
    GGF.Theme.LoadPlayer()
    GGF.UnitManager.unit["Player"]:Controls()
    GGF.UnitManager.unit["Player"]:Reload()
    GGF.UnitManager.frames.player:SetHidden(false)
  end
  if( section == nil or section == "Group" ) then
    GGF.Theme.LoadGroup()
    for i = 1, 3 do
      GGF.UnitManager.unit["Group"..i]:Controls()
    end
    GGF.UnitManager.UpdateGroup()
  end
  if( section == nil or section == "LargeGroup" ) then
    GGF.Theme.LoadLargeGroup()
    for i = 1, 24 do
      GGF.UnitManager.unit["LargeGroup"..i]:Controls()
    end
    GGF.UnitManager.UpdateGroup()
  end
  if( section == nil or section == "Target" ) then
    GGF.Theme.LoadTarget()
    GGF.UnitManager.unit["Target"]:Controls()
    GGF.UnitManager.unit["Target"]:Reload()
  end
  GGF.UnitManager.Controls()
end

--
-- Events
--

function GGF.UnitManager.RegisterEvents()
  -- Power Update (AKA: Health / Magicka / Stamina / Horse Stamina)
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_POWER_UPDATE, GGF.UnitManager.OnPowerUpdate)
  
  -- Death
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_UNIT_DEATH_STATE_CHANGED, GGF.UnitManager.OnUnitDeath)
  
  -- Experience / Level
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_LEVEL_UPDATE, GGF.UnitManager.OnUnitLevel)
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_VETERAN_RANK_UPDATE, GGF.UnitManager.OnUnitVetLevel)
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_EXPERIENCE_UPDATE, GGF.UnitManager.OnExpUpdate)
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_VETERAN_POINTS_UPDATE, GGF.UnitManager.OnExpUpdate)
  -- EVENT_ALLIANCE_POINT_UPDATE

  -- Mount
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_MOUNTED_STATE_CHANGED, GGF.UnitManager.OnMount )

  -- Group
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_GROUP_MEMBER_CONNECTED_STATUS, GGF.UnitManager.OnGroupMemberConnected)
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_GROUP_SUPPORT_RANGE_UPDATE,    GGF.UnitManager.OnGroupRangeUpdate)
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_LEADER_UPDATE,                 GGF.UnitManager.OnLeaderUpdate)
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_UNIT_CREATED,                  GGF.UnitManager.OnUnitUpdate)
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_UNIT_DESTROYED,                GGF.UnitManager.OnUnitUpdate)
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_GROUP_DISBANDED,               GGF.UnitManager.OnUnitUpdate)

  -- Target
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_TARGET_CHANGED,                GGF.UnitManager.OnTargetChange)
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_RETICLE_TARGET_CHANGED,        GGF.UnitManager.OnReticleTargetChange)

  -- Sheilds
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_UNIT_ATTRIBUTE_VISUAL_ADDED,   GGF.UnitManager.OnVisualizationAdded)
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_UNIT_ATTRIBUTE_VISUAL_REMOVED, GGF.UnitManager.OnVisualizationRemoved)
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_UNIT_ATTRIBUTE_VISUAL_UPDATED, GGF.UnitManager.OnVisualizationUpdated)

  -- Misc
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_PLAYER_COMBAT_STATE,           GGF.UnitManager.OnCombatStateChange)
  
  -- Testing
  EVENT_MANAGER:RegisterForEvent("GGF", EVENT_PLAYER_ALIVE,                  GGF.UnitManager.OnPlayerAlive)
end

----------------------------------------
-- Power Update
----------------------------------------

function GGF.UnitManager.OnPowerUpdate( eventCode , unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax )
  if ( IsReticleHidden() ) then return  end
  if ( powerType == POWERTYPE_HEALTH or ((powerType == POWERTYPE_MAGICKA or powerType == POWERTYPE_STAMINA) and unitTag == 'player' ) ) then 
    GGF.UnitManager.UnitFunction(unitTag, 'SetPower', powerIndex, powerType , powerValue , powerMax , powerEffectiveMax )
  elseif ( powerType == POWERTYPE_MOUNT_STAMINA and unitTag == 'player' ) then
    GGF.UnitManager.UnitFunction(unitTag, 'SetMountPower', powerIndex, powerType , powerValue , powerMax , powerEffectiveMax )
  end 
end

----------------------------------------
-- Death
----------------------------------------

function GGF.UnitManager.OnUnitDeath( eventCode, unitTag, isDead )
  GGF.UnitManager.UnitFunction(unitTag, 'SetDeath', isDead)
end

----------------------------------------
-- Level / Experience
----------------------------------------

function GGF.UnitManager.OnUnitLevel( eventCode, unitTag, level )
  GGF.UnitManager.UnitFunction(unitTag, 'SetLevel', level, GetUnitVeteranRank(unitTag))
end
function GGF.UnitManager.OnUnitVetLevel( eventCode, unitTag, rank )
  GGF.UnitManager.UnitFunction(unitTag, 'SetLevel', GetUnitLevel(unitTag), rank)
end

function GGF.UnitManager.OnExpUpdate( eventCode, unitTag, currentExp, maxExp, reason )
  if ( unitTag ~= "player" or reason == XP_REASON_FINESSE ) then return end
  GGF.UnitManager.UnitFunction(unitTag, 'SetExp', currentExp, maxExp, (eventCode==EVENT_VETERAN_POINTS_UPDATE))
end

----------------------------------------
-- Events: Mount
----------------------------------------

function GGF.UnitManager.OnMount( eventCode, isMounted )
  GGF.UnitManager.UnitFunction('player', 'SetMounted', isMounted)
end

----------------------------------------
-- Events: Groups
----------------------------------------

function GGF.UnitManager.OnLeaderUpdate( eventCode, ... )
  GGF.UnitManager.UpdateGroup()
end

function GGF.UnitManager.OnGroupMemberConnected( eventCode, unitTag, isOnline )
  GGF.UnitManager.UnitFunction(unitTag, 'SetConnected', isOnline)
end

function GGF.UnitManager.OnGroupRangeUpdate( event, unitTag, isWithinRange )
  GGF.UnitManager.UnitFunction(unitTag, 'SetRange', isWithinRange)
end

function GGF.UnitManager.OnUnitUpdate( eventCode, unitTag )
  if unitTag ~= nil and string.sub(unitTag,0,5) == "group" then
    GGF.UnitManager.UpdateGroup()
  end
end

----------------------------------------
-- Events: Target
----------------------------------------

function GGF.UnitManager.OnTargetChange( eventCode, unitTag )
  if unitTag ~= "player" then return end
  GGF.UnitManager.OnReticleTargetChange(eventCode)
end

function GGF.UnitManager.OnReticleTargetChange( eventCode )
  if DoesUnitExist("reticleover") then
    GGF.UnitManager.UnitFunction('reticleover', 'Reload')
    -- GGF.UnitManager.unit["Target"]:Reload()
  else
    GGF.UnitManager.UnitFunction('reticleover', 'Unload')
    -- GGF.UnitManager.unit["Target"]:Unload()
  end
  ZO_TargetUnitFramereticleover:SetHidden(true)
end

----------------------------------------
-- Events: Shields
----------------------------------------

-- ( eventCode, unitTag, unitAttributeVisual, statType, attributeType, powerType, value, maxValue )
-- Others: Decreased / Increased Max Power, Regen Power, or Stat | Unwavering Power | Automatic | None
function GGF.UnitManager.OnVisualizationAdded( eventCode, unitTag, unitAttributeVisual, statType, attributeType, powerType, value, maxValue )
  GGF.Debug:New("Visualization Added: ", {eventCode, unitTag, unitAttributeVisual, statType, attributeType, powerType, value, maxValue})
  
  if unitAttributeVisual ~= ATTRIBUTE_VISUAL_POWER_SHIELDING then return end
  GGF.UnitManager.UnitFunction(unitTag, 'UpdateShield', value, maxValue)
end

function GGF.UnitManager.OnVisualizationRemoved( eventCode, unitTag, unitAttributeVisual, statType, attributeType, powerType, value, maxValue )
  GGF.Debug:New("Visualization Removed: ", {eventCode, unitTag, unitAttributeVisual, statType, attributeType, powerType, value, maxValue})
  
  if unitAttributeVisual ~= ATTRIBUTE_VISUAL_POWER_SHIELDING then return end
  GGF.UnitManager.UnitFunction(unitTag, 'UpdateShield', 0, maxValue)
end

function GGF.UnitManager.OnVisualizationUpdated( eventCode, unitTag, unitAttributeVisual, statType, attributeType, powerType, oldValue, newValue, oldMax, newMax )
  GGF.Debug:New("Visualization Updated: ", {eventCode, unitTag, unitAttributeVisual, statType, attributeType, powerType, oldValue, newValue, oldMax, newMax})
  
  if unitAttributeVisual ~= ATTRIBUTE_VISUAL_POWER_SHIELDING then return end
  GGF.UnitManager.UnitFunction(unitTag, 'UpdateShield', newValue, newMax)
end

----------------------------------------
-- Events: Misc
----------------------------------------

function GGF.UnitManager.OnCombatStateChange( eventCode, isInCombat )
  GGF.UnitManager.frames.player:SetAlpha( isInCombat and 1 or GGF.SavedVars['Combat_Alpha']/100 )
  GGF.UnitManager.frames.group:SetAlpha( isInCombat and 1 or GGF.SavedVars['Combat_Alpha']/100 )
  GGF.UnitManager.frames.largeGroup:SetAlpha( isInCombat and 1 or GGF.SavedVars['Combat_Alpha']/100 )
  -- GGF.UnitManager.frames.target:SetAlpha( isInCombat and 1 or GGF.SavedVars['Combat_Alpha']/100 )
end

----------------------------------------
-- Events: Testing
----------------------------------------

function GGF.UnitManager.OnPlayerAlive( ... )
  GGF.Debug:New("On Player Alive", {...})
end









-- Events:
  -- ZO: EVENT_BOSSES_CHANGED
  -- ZO: EVENT_DISPOSITION_UPDATE
  -- ZO: EVENT_RANK_POINT_UPDATE
  -- Visual: EVENT_UNIT_ATTRIBUTE_VISUAL_ADDED 
  -- Visual: EVENT_UNIT_ATTRIBUTE_VISUAL_REMOVED 
  -- Visual: EVENT_UNIT_ATTRIBUTE_VISUAL_UPDATED 
  -- Siege: EVENT_BEGIN_SIEGE_CONTROL
  -- Siege: EVENT_END_SIEGE_CONTROL
  -- Combat: EVENT_PLAYER_COMBAT_STATE 
  -- Zone: EVENT_ZONE_UPDATE 
-- Zone: EVENT_ZONE_CHANGED 


-- GetUnitReaction(unitTag)
  -- UNIT_REACTION_FRIENDLY -- green
  -- UNIT_REACTION_HOSTILE  -- red
  -- UNIT_REACTION_INTERACT -- yellow
  -- UNIT_REACTION_DEAD 
  -- UNIT_REACTION_DEFAULT
  -- UNIT_REACTION_NEUTRAL
  -- UNIT_REACTION_NPC_ALLY
  -- UNIT_REACTION_PLAYER_ALLY

-- IsUnitPlayer(unitTag)
-- IsUnitAttackable(unitTag) -> boolean

-- CombatUnitType
  -- COMBAT_UNIT_TYPE_GROUP
  -- COMBAT_UNIT_TYPE_NONE
  -- COMBAT_UNIT_TYPE_OTHER
  -- COMBAT_UNIT_TYPE_PLAYER
  -- COMBAT_UNIT_TYPE_PLAYER_PET