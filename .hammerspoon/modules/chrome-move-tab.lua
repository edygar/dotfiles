-- modules/chrome-move-tab.lua
--
-- Move the active Chrome tab to another window.
-- Executed by Hammerspoon (called from Raycast UI via `hs -c`).
--
-- Uses Chrome's own tab context menu so the live tab is moved without creating
-- a replacement tab or reloading the page.

local usleep = hs.timer.usleep
local ax = require("hs.axuielement")

local M = {}

local function rightClick(x, y)
  local pt = { x = x, y = y }
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.rightMouseDown, pt):post()
  usleep(50000)
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.rightMouseUp, pt):post()
  usleep(300000)
end

local function escape()
  hs.eventtap.keyStroke({}, "escape")
  usleep(100000)
end

local function findElement(elem, predicate, depth)
  if not elem or depth > 12 then return nil end
  if predicate(elem) then return elem end
  for _, child in ipairs(elem.AXChildren or {}) do
    local found = findElement(child, predicate, depth + 1)
    if found then return found end
  end
  return nil
end

local function isContextMenu(elem)
  if tostring(elem.AXRole) ~= "AXMenu" then return false end
  local parent = elem.AXParent
  if parent and tostring(parent.AXRole) == "AXMenuBar" then return false end
  if parent and tostring(parent.AXRole) == "AXMenuBarItem" then return false end
  return true
end

local function waitForContextMenu(app, maxMs)
  local elapsed = 0
  local step = 100000
  while elapsed < maxMs do
    local menu = findElement(app, isContextMenu, 0)
    if menu then return menu end
    usleep(step)
    elapsed = elapsed + step
  end
  return nil
end

local function findSelectedTab(tabGroup)
  for _, tab in ipairs(tabGroup.AXChildren or {}) do
    if tostring(tab.AXRole) == "AXRadioButton" and tab.AXValue == true then
      return tab
    end
  end
  return nil
end

local function focusChromeWindow(windowId)
  local ok, err = hs.applescript(string.format([[
    tell application "Google Chrome"
      set windowIdStr to "%s" as string
      repeat with w in windows
        if ((id of w) as string) is windowIdStr then
          set index of w to 1
          activate
          return
        end if
      end repeat
      error "Chrome window not found"
    end tell
  ]], tostring(windowId)))

  if not ok then
    error(err or "Chrome window not found")
  end
end

local function openMoveSubmenu(menu)
  local moveItem = findElement(menu, function(elem)
    return tostring(elem.AXRole) == "AXMenuItem" and
           tostring(elem.AXTitle) == "Move Tab to Another Window"
  end, 0)

  if not moveItem then return nil end

  local submenu = findElement(moveItem, function(elem)
    return tostring(elem.AXRole) == "AXMenu"
  end, 0)
  if submenu then return submenu end

  moveItem:doAXPress()
  usleep(300000)

  return findElement(moveItem, function(elem)
    return tostring(elem.AXRole) == "AXMenu"
  end, 0)
end

local function openMenuBarMoveSubmenu(app)
  local menuBar = findElement(app, function(elem)
    return tostring(elem.AXRole) == "AXMenuBar"
  end, 0)
  if not menuBar then return nil end

  local tabMenuItem = nil
  for _, child in ipairs(menuBar.AXChildren or {}) do
    if tostring(child.AXRole) == "AXMenuBarItem" and tostring(child.AXTitle) == "Tab" then
      tabMenuItem = child
      break
    end
  end
  if not tabMenuItem then return nil end

  tabMenuItem:doAXPress()
  usleep(200000)

  local tabMenu = findElement(tabMenuItem, function(elem)
    return tostring(elem.AXRole) == "AXMenu"
  end, 0)
  if not tabMenu then return nil end

  local moveItem = findElement(tabMenu, function(elem)
    return tostring(elem.AXRole) == "AXMenuItem" and tostring(elem.AXTitle) == "Move Tab to Another Window"
  end, 0)
  if not moveItem then return nil end

  local submenu = findElement(moveItem, function(elem)
    return tostring(elem.AXRole) == "AXMenu"
  end, 0)
  if submenu then return submenu end

  moveItem:doAXPress()
  usleep(300000)

  return findElement(moveItem, function(elem)
    return tostring(elem.AXRole) == "AXMenu"
  end, 0)
end

local function stripTrailingEllipsis(value)
  return tostring(value or ""):gsub("%s*…$", "")
end

local function stripOtherTabsSuffix(value)
  return tostring(value or ""):gsub("%s+and%s+%d+%s+Other%s+Tabs?$", "")
end

local function isPrefixOfTarget(prefix, targetTitle, targetFullTitle)
  if prefix == "" then return false end
  return string.sub(targetTitle or "", 1, #prefix) == prefix or
         string.sub(targetFullTitle or "", 1, #prefix) == prefix
end

local function pluralizedOtherTabs(tabCount)
  local otherTabs = tonumber(tabCount or 0) - 1
  if otherTabs <= 0 then return nil end
  local suffix = otherTabs == 1 and "Other Tab" or "Other Tabs"
  return " and " .. tostring(otherTabs) .. " " .. suffix
end

local function titlesMatch(menuTitle, targetTitle, targetFullTitle, targetTabCount)
  if menuTitle == targetTitle or menuTitle == targetFullTitle then return true end

  local otherTabsSuffix = pluralizedOtherTabs(targetTabCount)
  if otherTabsSuffix then
    if menuTitle == tostring(targetTitle or "") .. otherTabsSuffix then return true end
    if menuTitle == tostring(targetFullTitle or "") .. otherTabsSuffix then return true end
  end

  local menuPrefix = stripTrailingEllipsis(menuTitle)
  if isPrefixOfTarget(menuPrefix, targetTitle, targetFullTitle) then return true end

  local menuTitleWithoutTabCount = stripOtherTabsSuffix(menuTitle)
  local menuPrefixWithoutTabCount = stripTrailingEllipsis(menuTitleWithoutTabCount)
  return isPrefixOfTarget(menuPrefixWithoutTabCount, targetTitle, targetFullTitle)
end

function M.doMoveToWindow(sourceWinId, targetWinId, targetTitle, targetFullTitle, targetTabCount)
  if not targetTitle or targetTitle == "" then
    error("Target Chrome window title is required")
  end

  focusChromeWindow(sourceWinId)
  usleep(300000)

  local chrome = hs.application.get("Google Chrome")
  if not chrome then error("Google Chrome is not running") end

  local app = ax.applicationElement(chrome)
  local win = app.AXFocusedWindow or (app.AXWindows or {})[1]
  if not win then error("Focused Chrome window not found") end

  local submenu = openMenuBarMoveSubmenu(app)
  if not submenu then
    local tabGroup = findElement(win, function(elem)
      return tostring(elem.AXRole) == "AXTabGroup"
    end, 0)
    if not tabGroup then error("Chrome tab group not found") end

    local tab = findSelectedTab(tabGroup)
    if not tab then error("Selected Chrome tab not found") end

    local pos = tab.AXPosition
    local size = tab.AXSize
    if not pos or not size then error("Selected Chrome tab position not found") end

    rightClick(math.floor(pos.x + size.w / 2), math.floor(pos.y + size.h / 2))

    local menu = waitForContextMenu(app, 2000000)
    if not menu then error("Chrome tab context menu not found") end

    submenu = openMoveSubmenu(menu)
  end
  if not submenu then
    escape()
    error("Move Tab to Another Window menu not found")
  end

  local targetItem = nil
  local availableTitles = {}
  for _, item in ipairs(submenu.AXChildren or {}) do
    if tostring(item.AXRole) == "AXMenuItem" then
      local title = tostring(item.AXTitle)
      availableTitles[#availableTitles + 1] = title
      if titlesMatch(title, targetTitle, targetFullTitle, targetTabCount) then
        targetItem = item
        break
      end
    end
  end

  if not targetItem then
    escape()
    error("Target Chrome window menu item not found: " .. targetTitle .. "; full title: " .. tostring(targetFullTitle) .. "; tab count: " .. tostring(targetTabCount) .. "; available: " .. table.concat(availableTitles, " | "))
  end

  targetItem:doAXPress()
  usleep(300000)
  focusChromeWindow(targetWinId)
end

function M.doMoveToNewWindow()
  local ok, err = hs.applescript([[
    tell application "Google Chrome" to activate
    delay 0.15
    tell application "System Events"
      tell process "Google Chrome"
        click menu item "Move Tab to New Window" of menu "Tab" of menu bar item "Tab" of menu bar 1
      end tell
    end tell
  ]])

  if not ok then
    error(err or "Failed to move Chrome tab to new window")
  end
end

return M
