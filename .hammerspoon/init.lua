-- init.lua — Hammerspoon entry point
--
-- Loads all modules from ~/.hammerspoon/modules/

-- Enable CLI access
hs.ipc.cliInstall()

-- Add modules directory to Lua package path
package.path = os.getenv("HOME") .. "/.hammerspoon/modules/?.lua;" .. package.path

local modules = {
  "chrome-move-tab",
  "menubar-cover",
}

local loaded = {}
for _, mod in ipairs(modules) do
  local ok, result = pcall(require, mod)
  if not ok then
    hs.notify.show("Hammerspoon error", "Failed to load " .. mod, tostring(result))
  else
    loaded[mod] = result
  end
end

if loaded["menubar-cover"] and loaded["menubar-cover"].start then
  loaded["menubar-cover"].start()
end

local okGridTile = pcall(hs.loadSpoon, "GridTile")
if okGridTile and spoon.GridTile then
  hs.hotkey.bind({ "cmd", "alt", "shift", "ctrl" }, "r", function()
    spoon.GridTile:start()
  end)
end

local appURLs = {
  ["Google Chrome"] = "raycast-x://extensions/jerome_soyer/chrome/move-tab-to-window",
  ["kitty"] = "raycast-x://extensions/jerome_soyer/kitty/move-tab-to-window",
}

if _G.moveTabToWindowEventtap then
  _G.moveTabToWindowEventtap:stop()
end

_G.moveTabToWindowEventtap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  if event:getKeyCode() ~= hs.keycodes.map.m then
    return false
  end

  local flags = event:getFlags()
  if not (flags.cmd and flags.shift) or flags.ctrl or flags.alt then
    return false
  end

  local app = hs.application.frontmostApplication()
  local url = app and appURLs[app:name()] or nil
  if not url then
    return false
  end

  hs.execute('open -g "' .. url .. '"', false)
  return true
end)
_G.moveTabToWindowEventtap:start()
