local ADDON_NAME, Addon = ...
local Colors = Addon.Colors
local Commands = Addon.Commands
local E = Addon.Events
local EventManager = Addon.EventManager
local L = Addon.Locale
local SavedVariables = Addon.SavedVariables

EventManager:Once(E.SavedVariablesReady, function()
  local frame = CreateFrame("Button", ADDON_NAME .. "_MerchantButton", MerchantFrame, "OptionsButtonTemplate")
  frame:SetText(ADDON_NAME)
  frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")

  if Addon.IS_RETAIL then
    frame:SetPoint("TOPRIGHT", MerchantFrameLootFilter, "TOPLEFT", -4, 0)
  else
    frame:SetPoint("TOPLEFT", 60, -28)
  end

  MerchantFrame:HookScript("OnUpdate", function()
    if SavedVariables:Get().merchantButton then
      frame:Show()
    else
      frame:Hide()
    end
  end)

  frame:HookScript("OnUpdate", function(self)
    self:SetEnabled(not Addon:IsBusy())
  end)

  frame:HookScript("OnClick", function(self, button)
    if button == "LeftButton" then
      Commands.sell()
    end

    if button == "RightButton" then
      if IsShiftKeyDown() then
        Commands.options()
      else
        Commands.junk()
      end
    end
  end)

  frame:HookScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
    GameTooltip:AddDoubleLine(Colors.Blue(ADDON_NAME), Addon.VERSION)
    GameTooltip:AddDoubleLine(L.LEFT_CLICK, Colors.White(L.START_SELLING))
    GameTooltip:AddDoubleLine(L.RIGHT_CLICK, Colors.White(L.TOGGLE_JUNK_FRAME))
    GameTooltip:AddDoubleLine(L.SHIFT_RIGHT_CLICK, Colors.White(L.TOGGLE_OPTIONS_FRAME))
    GameTooltip:Show()
  end)

  frame:HookScript("OnLeave", function()
    GameTooltip:Hide()
  end)
end)
