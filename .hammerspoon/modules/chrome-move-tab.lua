-- modules/chrome-move-tab.lua
--
-- Move the active Chrome tab to another window.
-- Executed by Hammerspoon (called from Raycast UI via `hs -c`).
--
-- IMPORTANT: All functions are SYNCHRONOUS so that `hs -c` blocks
-- until the entire operation completes.
--
-- Strategy:
--   1. Open a temporary tab with a unique title in the TARGET window.
--      This "names" the target window with a string we control.
--   2. Right-click the active tab in the SOURCE window (using AX for
--      exact tab position — no hardcoded offsets).
--   3. Navigate the context menu via the Accessibility API (no keyboard
--      typing) to "Move Tab to Another Window" > our unique title.
--   4. Close the temporary tab.

local APP_NAME = "Google Chrome"
local usleep = hs.timer.usleep
local ax = require("hs.axuielement")

local M = {}

local function rightClick(x, y)
  local pt = { x = x, y = y }
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.rightMouseDown, pt):post()
  usleep(50000)
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.rightMouseUp, pt):post()
  usleep(500000)
end

local function escape()
  hs.eventtap.keyStroke({}, "escape")
  usleep(100000)
end

local function findElement(elem, predicate, depth)
  if depth > 12 then return nil end
  if predicate(elem) then return elem end
  local children = elem.AXChildren or {}
  for _, c in ipairs(children) do
    local found = findElement(c, predicate, depth + 1)
    if found then return found end
  end
  return nil
end

local function findTabGroup(win)
  return findElement(win, function(e)
    return tostring(e.AXRole) == "AXTabGroup"
  end, 0)
end

local function isContextMenu(elem)
  if tostring(elem.AXRole) ~= "AXMenu" then return false end
  local parent = elem.AXParent
  if parent and tostring(parent.AXRole) == "AXMenuBar" then return false end
  if parent and tostring(parent.AXRole) == "AXMenuBarItem" then return false end
  return true
end

local function findContextMenu(app)
  return findElement(app, isContextMenu, 0)
end

local function waitForContextMenu(app, maxMs)
  local step = 100000
  local elapsed = 0
  while elapsed < maxMs do
    local menu = findContextMenu(app)
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

local function cleanupTempTab(uniqueId)
  hs.applescript(string.format([[
    tell application "Google Chrome"
      repeat with w in windows
        repeat with t in tabs of w
          if URL of t contains "%s" then
            close t
            exit repeat
          end if
        end repeat
      end repeat
    end tell
  ]], uniqueId))
end

function M.doMoveToWindow(sourceWinId, targetWinId)
  local uniqueId = "mt" .. tostring(hs.timer.us() % 1000000)
  local tmpUrl = "data:text/html,<title>" .. uniqueId .. "</title>"

  hs.applescript(string.format([[
    tell application "Google Chrome"
      set sourceWinIdStr to "%s" as string
      repeat with w in windows
        set winIdStr to (id of w) as string
        if winIdStr is sourceWinIdStr then
          set index of w to 1
          exit repeat
        end if
      end repeat
      activate
    end tell
  ]], tostring(sourceWinId)))
  usleep(300000)

  hs.applescript(string.format([[
    tell application "Google Chrome"
      set targetWinIdStr to "%s" as string
      repeat with w in windows
        set winIdStr to (id of w) as string
        if winIdStr is targetWinIdStr then
          make new tab at end of tabs of w with properties {URL:"%s"}
          set active tab index of w to (count of tabs of w)
          exit repeat
        end if
      end repeat
    end tell
  ]], tostring(targetWinId), tmpUrl))
  usleep(1000000)

  local menu = nil
  for _ = 1, 3 do
    local chrome = hs.application.get("Google Chrome")
    if not chrome then break end
    local app = ax.applicationElement(chrome)
    local win = app.AXFocusedWindow or app.AXWindows[1]
    if not win then break end
    local tabGroup = findTabGroup(win)
    if not tabGroup then break end
    local tab = findSelectedTab(tabGroup)
    if not tab then break end
    local pos = tab.AXPosition
    local sz = tab.AXSize
    if not pos or not sz then break end
    local cx = math.floor(pos.x + sz.w / 2)
    local cy = math.floor(pos.y + sz.h / 2)

    rightClick(cx, cy)
    menu = waitForContextMenu(app, 2000000)
    if menu then break end
  end
  if not menu then
    cleanupTempTab(uniqueId)
    return
  end

  local moveItem = findElement(menu, function(e)
    return tostring(e.AXRole) == "AXMenuItem" and
           tostring(e.AXTitle) == "Move Tab to Another Window"
  end, 0)
  if not moveItem then
    escape()
    cleanupTempTab(uniqueId)
    return
  end

  local submenu = findElement(moveItem, function(e)
    return tostring(e.AXRole) == "AXMenu"
  end, 0)
  if not submenu then
    escape()
    cleanupTempTab(uniqueId)
    return
  end

  local targetItem = nil
  for _, item in ipairs(submenu.AXChildren or {}) do
    if tostring(item.AXRole) == "AXMenuItem" and
       tostring(item.AXTitle) == uniqueId then
      targetItem = item
      break
    end
  end

  if not targetItem then
    escape()
    cleanupTempTab(uniqueId)
    return
  end

  targetItem:doAXPress()
  usleep(500000)
  cleanupTempTab(uniqueId)
end

function M.doMoveToNewWindow()
  hs.applescript([[
    tell application "Google Chrome" to activate
    delay 0.15
    tell application "System Events"
      tell process "Google Chrome"
        click menu item "Move Tab to New Window" of menu "Tab" of menu bar item "Tab" of menu bar 1
      end tell
    end tell
  ]])
end

return M