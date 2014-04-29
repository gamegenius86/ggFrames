GGF.Settings = ZO_Object:Subclass()

-- Create and Initialize a NEW Settings Object (OOP FTW)
function GGF.Settings:New()
  local self = ZO_Object.New( self )
  self:Controls()
  return self
end

function GGF.Settings:GetValue(field)
  return GGF.SavedVars[field]
end

function GGF.Settings:SetValue(field, val)
  GGF.Debug:New("Set Value of "..field, val)
  GGF.SavedVars[field] = val
  local s, _ = string.find(field,"_")
  local section = string.sub(field, 0, s-1)
  GGF.UnitManager.RefreshControls(section)
end

function GGF.Settings:GetColor(field)
  return unpack(GGF.SavedVars[field])
end

function GGF.Settings:SetColor(field, r, g, b, a)
  GGF.SavedVars[field] = {r,g,b,a}
  local s, _ = string.find(field,"_")
  local section = string.sub(field, 0, s-1)
  GGF.UnitManager.RefreshControls(section)
end

function GGF.Settings:IsFrameMovable()
  return GGF.move
end
function GGF.Settings:ToggleFrameMovable(alert)
  GGF.move = not GGF.move

  if not GGF.move then
    GGF.SavedVars['PlayerContainer_OffsetX'] = GGF.UnitManager.frames.player:GetLeft()
    GGF.SavedVars['PlayerContainer_OffsetY'] = GGF.UnitManager.frames.player:GetTop()
    GGF.SavedVars['GroupContainer_OffsetX'] = GGF.UnitManager.frames.group:GetLeft()
    GGF.SavedVars['GroupContainer_OffsetY'] = GGF.UnitManager.frames.group:GetTop()
    GGF.SavedVars['LargeGroupContainer_OffsetX'] = GGF.UnitManager.frames.largeGroup:GetLeft()
    GGF.SavedVars['LargeGroupContainer_OffsetY'] = GGF.UnitManager.frames.largeGroup:GetTop()
    GGF.SavedVars['TargetContainer_OffsetX'] = GGF.UnitManager.frames.target:GetLeft()
    GGF.SavedVars['TargetContainer_OffsetY'] = GGF.UnitManager.frames.target:GetTop()
    GGF.UnitManager.RefreshControls()
  end 

  GGF.UnitManager.SetMovable()
end

function GGF.Settings:ResetDefaults()
  for key, value in pairs(GGF.SavedVarsDefaults) do
    GGF.SavedVars[key] = value
  end

  GGF.UnitManager.RefreshControls()
end