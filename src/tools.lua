-- Tools: a collection of helpful functions.

local AddonName, Addon = ...
local assert = assert
local Colors = Addon.Colors
local Consts = Addon.Consts
local DB = Addon.DB
local DCL = Addon.Libs.DCL
local floor = math.floor
local GetMoney = _G.GetMoney
local L = Addon.Libs.L
local ListManager = Addon.ListManager
local max = math.max
local StaticPopup_Show = _G.StaticPopup_Show
local Tools = Addon.Tools

-- ============================================================================
-- List Name Functions
-- ============================================================================

-- Returns the localized Inclusions string in color.
function Tools:GetInclusionsString()
  return DCL:ColorString(L.INCLUSIONS_TEXT, Colors.Inclusions)
end

-- Returns the localized Exclusions string in color.
function Tools:GetExclusionsString()
  return DCL:ColorString(L.EXCLUSIONS_TEXT, Colors.Exclusions)
end

-- Returns the localized Destroyables string in color.
function Tools:GetDestroyablesString()
  return DCL:ColorString(L.DESTROYABLES_TEXT, Colors.Destroyables)
end

-- Returns the list name as a localized string in color.
-- @param listName - a list name key defined in ListManager
function Tools:GetColoredListName(listName)
  assert(ListManager.Lists[listName])

  if (listName == "Inclusions") then
    return self:GetInclusionsString()
  elseif (listName == "Exclusions") then
    return self:GetExclusionsString()
  elseif (listName == "Destroyables") then
    return self:GetDestroyablesString()
  else
    error(format("Unsupported list name: \"%s\"", listName))
  end
end

-- ============================================================================
-- Item Functions
-- ============================================================================

-- Gets the item id from a specified item link.
-- @return - the item id, or nil
function Tools:GetItemIDFromLink(itemLink)
  return (itemLink and itemLink:match("item:(%d+)")) or nil
end

-- Returns true if the specified item can be sold.
-- @param item - the item
function Tools:ItemCanBeSold(item)
  return (item.Price > 0 and (item.Quality >= LE_ITEM_QUALITY_POOR and item.Quality <= LE_ITEM_QUALITY_EPIC))
end

-- Returns true if the specified item can be destroyed.
-- @param item - the item
function Tools:ItemCanBeDestroyed(item)
  -- Disallow destroying of Pet Cages
  if (item.Class == Consts.BATTLEPET_CLASS) then return false end
  return (item.Quality >= LE_ITEM_QUALITY_POOR and item.Quality <= LE_ITEM_QUALITY_EPIC)
end

-- Returns true if the specified item can be refunded.
-- @param item - the item
function Tools:ItemCanBeRefunded(item)
  local refundTimeRemaining = select(3, GetContainerItemPurchaseInfo(item.Bag, item.Slot))
  return refundTimeRemaining and (refundTimeRemaining > 0)
end

-- ============================================================================
-- Popup Functions
-- ============================================================================

do -- DEJUNK_YES_NO_POPUP
  local DEJUNK_YES_NO_POPUP = {
    button1 = _G.YES,
    button2 = _G.NO,
    showAlert = 1,
    timeout = 0,
    exclusive = 1,
    whileDead = 1,
    hideOnEscape = 1
  }
  _G.StaticPopupDialogs.DEJUNK_YES_NO_POPUP = DEJUNK_YES_NO_POPUP

  --[[
    Shows a simple Yes or No popup for confirming an action.

    options = {
      text = string,
      onAccept = function,
      onCancel = function,
      onShow = function,
      onHide = function
    }
  ]]
  function Tools:YesNoPopup(options)
    DEJUNK_YES_NO_POPUP.text = options.text
    DEJUNK_YES_NO_POPUP.OnAccept = options.onAccept
    DEJUNK_YES_NO_POPUP.OnCancel = options.onCancel
    DEJUNK_YES_NO_POPUP.OnShow = options.onShow
    DEJUNK_YES_NO_POPUP.OnHide = options.onHide
    StaticPopup_Show("DEJUNK_YES_NO_POPUP")
  end
end
