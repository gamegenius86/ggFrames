GGF.Window = {}

-- Create Controls, set dimensions and anchors
function GGF.Window:Create(cName, cParent, cType, cTemplate)
  local control = _G[cName]
  if (control == nil) then
    if (cType == 4) then 
      control = CreateTopLevelWindow(cName)
    else 
      control = WINDOW_MANAGER:CreateControl(cName, cParent, cType)
    end
    if cTemplate.Hidden == true then control:SetHidden(cTemplate.Hidden) end
    if cTemplate.DrawLayer then control:SetDrawLayer(cTemplate.DrawLayer) end
  end
  control:SetAlpha(cTemplate.Alpha or 1)    
  control:SetDimensions(cTemplate.Width, cTemplate.Height)
  control:ClearAnchors()
  control:SetAnchor((cTemplate.MyAnchor or TOPLEFT), cParent, (cTemplate.ParentAnchor or TOPLEFT), (cTemplate.OffsetX or 0), (cTemplate.OffsetY or 0))    
  return control
end

-- Create Backdrops
function GGF.Window:CreateBackDrop(cName, cParent, cTemplate)
  local backdrop = GGF.Window:Create(cName, cParent, CT_BACKDROP, cTemplate)
  
  if cTemplate.BackColor then
    backdrop:SetCenterColor(cTemplate.BackColor[1], cTemplate.BackColor[2], cTemplate.BackColor[3], cTemplate.BackColor[4])
  end
  if cTemplate.EdgeColor and cTemplate.EdgeWeight then
    backdrop:SetEdgeColor(cTemplate.EdgeColor[1], cTemplate.EdgeColor[2], cTemplate.EdgeColor[3], cTemplate.EdgeColor[4])
    backdrop:SetEdgeTexture("", 8, 1, cTemplate.EdgeWeight)
  end
  return backdrop
end

-- Create Labels
function GGF.Window:CreateLabel(cName, cParent, cTemplate)
  local label = GGF.Window:Create(cName, cParent, CT_LABEL, cTemplate)

  label:SetFont(cTemplate.Font)
  label:SetHorizontalAlignment(cTemplate.HorizontalAlign or TEXT_ALIGN_LEFT)
  label:SetVerticalAlignment(TEXT_ALIGN_CENTER)
  label:SetColor(cTemplate.FontColor[1], cTemplate.FontColor[2], cTemplate.FontColor[3], cTemplate.FontColor[4])
  label:SetWrapMode(TEXT_WRAP_MODE_ELLIPSIS)

  if cTemplate.Hidden then label:SetHidden(cTemplate.Hidden) end
  return label
end

-- Create Status Bars
function GGF.Window:CreateStatusBar(cName, cParent, cTemplate)
  local status = GGF.Window:Create(cName, cParent, CT_STATUSBAR, cTemplate)
  status:SetTexture(cTemplate.Texture)
  status:SetColor(cTemplate.BarColor[1], cTemplate.BarColor[2], cTemplate.BarColor[3], cTemplate.BarColor[4])
  return status
end

-- Create Texture
function GGF.Window:CreateTexture(cName, cParent, cTemplate)
  local texture = GGF.Window:Create(cName, cParent, CT_TEXTURE, cTemplate)
  texture:SetTexture(cTemplate.Texture)
  if cTemplate.Rotate then texture:SetTextureRotation(cTemplate.Rotate) end
  return texture
end

-- Create Texture
function GGF.Window:CreateAnimatedTexture(cName, cParent, cTemplate)
  local texture = GGF.Window:CreateTexture(cName, cParent, cTemplate)
  local animation, timeline = CreateSimpleAnimation(ANIMATION_TEXTURE, texture)
  animation:SetImageData(cTemplate['ImageData'][1], cTemplate['ImageData'][2])
  animation:SetFramerate(cTemplate['Framerate'])
  animation:SetDuration(cTemplate['Duration'])
  timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, LOOP_INDEFINITELY)
  
  -- timeline:IsPlaying()
  -- timeline:PlayFromStart()
  -- timeline:Stop()

  return texture, timeline
end






function GGF.Window:SetLabelText( label, text, resize )
  if resize then 
    local maxWidth = label:GetParent():GetWidth() - 60
    label:SetWidth( maxWidth )
    label:SetText(text)
    label:SetWrapMode( label:GetTextWidth() > maxWidth and TEXT_WRAP_MODE_ELLIPSIS or NONE )
    label:SetWidth( label:GetTextWidth() ) 
  else
    label:SetText(text)
  end
end

function GGF.Window:SetAdditionalLeftOffset( control, cTemplate, additional )
  control:ClearAnchors()
  control:SetAnchor((cTemplate.MyAnchor or TOPLEFT), cParent, (cTemplate.ParentAnchor or TOPLEFT), ((cTemplate.OffsetX or 0) + additional), (cTemplate.OffsetY or 0))
end

function GGF.Window:SetOffsetY( control, newOffsetY )
  local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY = control:GetAnchor()
  control:ClearAnchors()
  control:SetAnchor(point, relativeTo, relativePoint, offsetX, newOffsetY)
end