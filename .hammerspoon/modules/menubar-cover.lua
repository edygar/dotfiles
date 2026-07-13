-- modules/menubar-cover.lua
--
-- Hides SketchyBar items (not the bar itself) when the auto-hide menu bar
-- slides down, so they don't show through the translucent menu bar.
-- The bar background stays visible; only the items are toggled.

local M = {}

local POLL_INTERVAL = 0.1
local RESTORE_DELAY = 0.2
local ANIMATION_DURATION = 12

local menuBarHeight = 30
local menuBarTriggerY = 1
local pollTimer = nil
local restoreTimer = nil
local hideFinishTimer = nil
local hidden = false
local SKETCHYBAR = "/opt/homebrew/bin/sketchybar"
local originalColors = {}

local fallbackItems = {
  "space.A", "space.S", "space.D", "space.F", "space.Z",
  "space.X", "space.V", "space.Q", "space.R", "space.T",
  "space_separator", "front_app", "media", "calendar",
  "volume", "battery", "cpu",
}

local function getItems()
  local raw = hs.execute(SKETCHYBAR .. " --query bar 2>/dev/null", false)
  if raw and raw ~= "" then
    local ok, data = pcall(hs.json.decode, raw)
    if ok and data and data.items and #data.items > 0 then
      return data.items
    end
  end
  return fallbackItems
end

local function transparent(color)
  if type(color) ~= "string" then return nil end
  return color:gsub("^0x..", "0x00")
end

local function cacheOriginalColors()
  for _, item in ipairs(getItems()) do
    if not originalColors[item] then
      local raw = hs.execute(SKETCHYBAR .. " --query " .. item .. " 2>/dev/null", false)
      local ok, data = pcall(hs.json.decode, raw or "")
      if ok and data then
        originalColors[item] = {
          icon = data.icon and data.icon.color or nil,
          label = data.label and data.label.color or nil,
          background = data.geometry and data.geometry.background and data.geometry.background.color or nil,
        }
      end
    end
  end
end

local function buildColorArgs(on)
  local args = {}
  for _, item in ipairs(getItems()) do
    local colors = originalColors[item]
    if colors then
      local parts = { "--set " .. item }
      if colors.icon then
        parts[#parts + 1] = "icon.color=" .. (on and colors.icon or transparent(colors.icon))
      end
      if colors.label then
        parts[#parts + 1] = "label.color=" .. (on and colors.label or transparent(colors.label))
      end
      if colors.background then
        parts[#parts + 1] = "background.color=" .. (on and colors.background or transparent(colors.background))
      end
      args[#args + 1] = table.concat(parts, " ")
    end
  end
  return args
end

local function setItemsDrawing(on)
  local drawing = on and "on" or "off"
  local args = {}
  for _, item in ipairs(getItems()) do
    args[#args + 1] = "--set " .. item .. " drawing=" .. drawing
  end
  if #args > 0 then
    hs.execute(SKETCHYBAR .. " " .. table.concat(args, " "), false)
  end
end

local function animateItems(on)
  cacheOriginalColors()
  local args = buildColorArgs(on)
  if #args > 0 then
    hs.execute(SKETCHYBAR .. " --animate tanh " .. ANIMATION_DURATION .. " " .. table.concat(args, " "), false)
  end
end

local function cancelRestore()
  if restoreTimer then
    restoreTimer:stop()
    restoreTimer = nil
  end
end

local function cancelHideFinish()
  if hideFinishTimer then
    hideFinishTimer:stop()
    hideFinishTimer = nil
  end
end

local function hideItems()
  cancelRestore()
  cancelHideFinish()
  if hidden then return end
  animateItems(false)
  hideFinishTimer = hs.timer.doAfter(ANIMATION_DURATION / 60 + 0.05, function()
    if hidden then
      setItemsDrawing(false)
    end
    hideFinishTimer = nil
  end)
  hidden = true
end

local function scheduleRestore()
  if not hidden or restoreTimer then return end
  restoreTimer = hs.timer.doAfter(RESTORE_DELAY, function()
    restoreTimer = nil
    if hs.mouse.absolutePosition().y > menuBarHeight then
      cancelHideFinish()
      setItemsDrawing(true)
      animateItems(true)
      hidden = false
    end
  end)
end

local function startPolling()
  if pollTimer then return end
  pollTimer = hs.timer.new(POLL_INTERVAL, function()
    local pos = hs.mouse.absolutePosition()
    if pos.y <= menuBarTriggerY then
      hideItems()
    elseif pos.y > menuBarHeight then
      scheduleRestore()
    end
  end)
  pollTimer:start()
end

function M.start()
  cacheOriginalColors()
  setItemsDrawing(true)
  animateItems(true)
  hidden = false
  startPolling()
end

function M.stop()
  if pollTimer then
    pollTimer:stop()
    pollTimer = nil
  end
  cancelRestore()
  cancelHideFinish()
  if hidden then
    setItemsDrawing(true)
    animateItems(true)
    hidden = false
  end
end

return M
