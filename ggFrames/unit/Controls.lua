GGF.classTextures = {
  ["Sorcerer"] = "/esoui/art/contacts/social_classicon_sorcerer.dds",
  ["Templar"] = "/esoui/art/contacts/social_classicon_templar.dds",
  ["Dragonknight"] = "/esoui/art/contacts/social_classicon_dragonknight.dds",
  ["Nightblade"] = "/esoui/art/contacts/social_classicon_nightblade.dds"
}

-- Create Player Frames
function GGF.Unit:Controls()
  self.template = GGF.Theme.Load(self.unitName)   -- Load Template (For Rendering)

  -- Draw Main Control
  self.frames.main = GGF.Window:CreateBackDrop("GGF_"..self.unitName.."Frame", self.parent, self.template)

  -- Draw Name and Class (Level)
  if self.template.Name ~= false    then self.frames.nameLb  = GGF.Window:CreateLabel("GGF_"..self.unitName.."NameLB", self.frames.main, self.template.Name);         self.frames.nameLb:SetHidden(false)    elseif self.frames.nameLb ~= nil then self.frames.nameLb:SetHidden(true) end
  if self.template.Level ~= false   then self.frames.levelLb = GGF.Window:CreateLabel("GGF_"..self.unitName.."LevelLb", self.frames.nameLb, self.template.Level);     self.frames.levelLb:SetHidden(false)   elseif self.frames.levelLb ~= nil then self.frames.levelLb:SetHidden(true) end
  if self.template.Class ~= false   then self.frames.classTx = GGF.Window:CreateTexture("GGF_"..self.unitName.."ClassTx", self.frames.main, self.template.Class);     self.frames.classTx:SetHidden(false)   elseif self.frames.classTx ~= nil then self.frames.classTx:SetHidden(true) end
  if self.template.Leader ~= false  then self.frames.leaderTx = GGF.Window:CreateTexture("GGF_"..self.unitName.."LeadTx", self.frames.main, self.template.Leader);                                           elseif self.frames.leaderTx ~= nil then self.frames.leaderTx:SetHidden(true) end
  if self.template.Caption ~= false then self.frames.captionLb = GGF.Window:CreateLabel("GGF_"..self.unitName.."CaptionLb", self.frames.main, self.template.Caption); self.frames.captionLb:SetHidden(false) elseif self.frames.captionLb ~= nil then self.frames.captionLb:SetHidden(true) end

  -- Misc Labels
  self.frames.death     = GGF.Window:CreateBackDrop("GGF_"..self.unitName.."Death", self.frames.main, self.template.Death)
  self.frames.deathLb   = GGF.Window:CreateLabel("GGF_"..self.unitName.."DeathText", self.frames.death, self.template.Death.Label)
  self.frames.deathLb:SetText("Dead")
  self.frames.offline   = GGF.Window:CreateBackDrop("GGF_"..self.unitName.."Offline", self.frames.main, self.template.Offline)
  self.frames.offlineLb = GGF.Window:CreateLabel("GGF_"..self.unitName.."OfflineText", self.frames.offline, self.template.Offline.Label)
  self.frames.offlineLb:SetText("Offline")

  -- Health
  self.frames.healthBd      = GGF.Window:CreateBackDrop("GGF_"..self.unitName.."Health", self.frames.main, self.template.Health)
  self.frames.healthSt      = GGF.Window:CreateStatusBar("GGF_"..self.unitName.."HealthStatusBar", self.frames.healthBd, self.template.Health.Bar)
  if self.template.Health.LabelOne ~= false then self.frames.healthLbOne  = GGF.Window:CreateLabel("GGF_"..self.unitName.."HealthLabelOne",  self.frames.healthBd, self.template.Health.LabelOne) end
  if self.template.Health.LabelTwo ~= false then self.frames.healthLbTwo  = GGF.Window:CreateLabel("GGF_"..self.unitName.."HealthLabelTwo",  self.frames.healthBd, self.template.Health.LabelTwo) end

  -- Magicka
  if self.template.Magicka ~= false then
    self.frames.magickaBd  = GGF.Window:CreateBackDrop("GGF_"..self.unitName.."Magicka", self.frames.main, self.template.Magicka)
    self.frames.magickaSt  = GGF.Window:CreateStatusBar("GGF_"..self.unitName.."MagickaStatusBar", self.frames.magickaBd, self.template.Magicka.Bar)
    if self.template.Magicka.LabelOne ~= false then self.frames.magickaLbOne  = GGF.Window:CreateLabel("GGF_"..self.unitName.."MagickaLabelOne",  self.frames.magickaBd, self.template.Magicka.LabelOne) end
    if self.template.Magicka.LabelTwo ~= false then self.frames.magickaLbTwo  = GGF.Window:CreateLabel("GGF_"..self.unitName.."MagickaLabelTwo",  self.frames.magickaBd, self.template.Magicka.LabelTwo) end
  end

  -- Stamina
  if self.template.Stamina ~= false then
    self.frames.staminaBd  = GGF.Window:CreateBackDrop("GGF_"..self.unitName.."Stamina", self.frames.main, self.template.Stamina)
    self.frames.staminaSt  = GGF.Window:CreateStatusBar("GGF_"..self.unitName.."StaminaStatusBar", self.frames.staminaBd, self.template.Stamina.Bar)
    if self.template.Stamina.LabelOne ~= false then self.frames.staminaLbOne  = GGF.Window:CreateLabel("GGF_"..self.unitName.."StaminaLabelOne",  self.frames.staminaBd, self.template.Stamina.LabelOne) end
    if self.template.Stamina.LabelTwo ~= false then self.frames.staminaLbTwo  = GGF.Window:CreateLabel("GGF_"..self.unitName.."StaminaLabelTwo",  self.frames.staminaBd, self.template.Stamina.LabelTwo) end
  end

  -- Mount
  if self.template.Mount ~= false then
    self.frames.mount      = GGF.Window:CreateBackDrop("GGF_"..self.unitName.."Mount", self.frames.main, self.template.Mount)
    self.frames.mountBd    = GGF.Window:CreateBackDrop("GGF_"..self.unitName.."MountBd", self.frames.mount, self.template.Mount.BarArea)
    self.frames.mountSt    = GGF.Window:CreateStatusBar("GGF_"..self.unitName.."MountSt", self.frames.mountBd, self.template.Mount.BarArea.Bar)
    self.frames.mountTx    = GGF.Window:CreateTexture("GGF_"..self.unitName.."MountTx", self.frames.mount, self.template.Mount.Icon)
  end

  -- Exp
  if self.template.Experience ~= false then
    self.frames.experienceBd   = GGF.Window:CreateBackDrop("GGF_"..self.unitName.."Experience", self.frames.main, self.template.Experience)
    self.frames.experienceSt   = GGF.Window:CreateStatusBar("GGF_"..self.unitName.."ExperienceStatusBar", self.frames.experienceBd, self.template.Experience.Bar)
    if self.template.Experience.Label ~= false then
      self.frames.experienceLb   = GGF.Window:CreateLabel("GGF_"..self.unitName.."ExperienceLabel", self.frames.experienceBd, self.template.Experience.Label)
      self.frames.experienceLb:SetHidden(false)
    elseif self.frames.experienceLb ~= nil then
      self.frames.experienceLb:SetHidden(true)
    end
    self.frames.experienceBd:SetHidden(false)
  elseif self.frames.experienceBd ~= nil then
    self.frames.experienceBd:SetHidden(true)
  end

  -- Click Handler
  -- self.frames.main:SetMouseEnabled(true)
  -- self.frames.main:SetHandler("OnMouseUp", function(self, btn, upInside) d("Clicking on unit frames will be coming soon") end)
end

function GGF.Unit:SetPosition()
end


-- function GGF.GenerateCastBar()
-- end