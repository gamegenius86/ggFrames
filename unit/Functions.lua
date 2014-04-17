GGF.classTextures = {
  ["Sorcerer"] = "/esoui/art/contacts/social_classicon_sorcerer.dds",
  ["Templar"] = "/esoui/art/contacts/social_classicon_templar.dds",
  ["Dragonknight"] = "/esoui/art/contacts/social_classicon_dragonknight.dds",
  ["Nightblade"] = "/esoui/art/contacts/social_classicon_nightblade.dds"
}

GGF.Unit = {}

-- Create and Initialize a NEW PlayerModule Object (OOP FTW)
function GGF.Unit.Initialize(unitTag)
  local self = GGF.Utils:ShallowCopy(GGF.Unit)
  
  -- Load Information
  self.unitTag = unitTag
  self.race  = GetUnitRace(self.unitTag)
  self.isDPS, self.isHeal, self.isTank = GetGroupMemberRoles(self.unitTag)
  self.isLead = IsUnitGroupLeader(self.unitTag)

  -- Load Template (For Rendering)
  self.template = GGF.Utils:TableMerge(GGF.Template.Base, GGF.Template[self.unitTag])

  -- Create Frames / Controls
  self:Controls()

  self:LoadInitialData()

  -- Ensure the default unit frames are hidden
  ZO_PlayerAttribute:SetHidden( true )
  
  return self
end

function GGF.Unit:LoadInitialData()
  self.name   = GetUnitName(self.unitTag)
  self.class  = GetUnitClass(self.unitTag)
  self.level  = GetUnitLevel(self.unitTag)
  self.exp    = GetUnitXP(self.unitTag)
  self.expMax = GetUnitXPMax(self.unitTag)
  self.vlevel = GetUnitVeteranRank(self.unitTag)
  self.vet    = GetUnitVeteranPoints(self.unitTag)
  self.vetMax = GetUnitVeteranPointsMax(self.unitTag)
  self.levelProgress = math.floor( ((self.vet or self.exp) / (self.vetMax or self.expMax))*100 )

  self.frames.nameLb:SetText(self.name.." ("..(self.level == 50 and "Vet "..self.vlevel or self.level)..")")
  self.frames.classTx:SetTexture(GGF.classTextures[self.class])
  self.frames.experienceSt:SetWidth( ( self.levelProgress / 100 ) * self.template.Experience.Width )
end



-- Call From OnPowerUpdate Event
function GGF.Unit:SetPower( powerIndex, powerType,  powerValue, powerMax, powerEffectiveMax )
  -- local powerIndexField = {1 = "magicka", 3 = "stamina", 999 = "health"}
  -- Get the power field
  local field = ""
  if     ( powerType == POWERTYPE_HEALTH  ) then field = {friendly = "health",  label = "Health"}
  elseif ( powerType == POWERTYPE_MAGICKA ) then field = {friendly = "magicka", label = "Magicka"}
  elseif ( powerType == POWERTYPE_STAMINA ) then field = {friendly = "stamina", label = "Stamina"}
  else return end

  -- Update Local Info
  self[field.friendly] = {current = powerValue, max = powerMax, percent = math.floor( ( powerValue / powerEffectiveMax ) * 100 )}

  self.frames[field.friendly.."St"]:SetWidth( ( self[field.friendly].percent / 100 ) * self.template[field.label].Bar.Width )
  self.frames[field.friendly.."LeftLb"]:SetText( powerValue )
  self.frames[field.friendly.."RightLb"]:SetText( self[field.friendly].percent .. "%" )
end

function GGF.Unit:SetMountPower( powerIndex, powerType, powerValue, powerMax, powerEffectiveMax )

end

-- Call From OnLevel Event
function GGF.Unit:SetLevel( level )
  self.level = level
  self.frames.nameLb:SetText(self.name.." ("..(self.level == 50 and "Vet "..self.vlevel or self.level)..")")
end

-- Call From OnExpUpdate Event
function GGF.Unit:SetExp( current, max, veteran )
  if veteran then
    self.vet = current
    self.vetMax = max
  else
    self.exp = current
    self.expMax = max
  end
  self.levelProgress = math.floor( ((self.vet or self.exp) / (self.vetMax or self.expMax))*100 )
  self.frames.experienceSt:SetWidth( ( self.levelProgress / 100 ) * self.template.ExpBar.Width )
end

-- IsUnitDead(unit)
function GGF.Unit:SetDeath( isDead )
  -- If UnitTag == 'player' or groupX
  self.frames.healthBd:SetHidden(  isDead )
  self.frames.magickaBd:SetHidden( isDead )
  self.frames.staminaBd:SetHidden( isDead )
  self.frames.deathLb:SetHidden( not isDead )
end