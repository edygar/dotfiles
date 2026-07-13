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

-- App-specific cmd+shift+m bindings
local KEY_MODS = { "cmd", "shift" }
local KEY_KEY = "m"

local appHotkeys = {}
local appURLs = {
  ["Google Chrome"] = "raycast://extensions/jerome_soyer/chrome/move-tab-to-window",
  ["kitty"] = "raycast://extensions/jerome_soyer/kitty/move-tab-to-window",
}

local function bindForApp(appName)
  local url = appURLs[appName]
  if not url then return end
  if appHotkeys[appName] then
    appHotkeys[appName]:enable()
  else
    appHotkeys[appName] = hs.hotkey.new(KEY_MODS, KEY_KEY, function()
      hs.execute('open -g "' .. url .. '"', false)
    end)
    appHotkeys[appName]:enable()
  end
end

local function unbindForApp(appName)
  if appHotkeys[appName] then
    appHotkeys[appName]:disable()
  end
end

local function onAppEvent(appName, eventType)
  if eventType == hs.application.watcher.activated then
    for name, _ in pairs(appURLs) do
      if name == appName then
        bindForApp(name)
      else
        unbindForApp(name)
      end
    end
  elseif eventType == hs.application.watcher.deactivated then
    unbindForApp(appName)
  end
end

local appWatcher = hs.application.watcher.new(onAppEvent)
appWatcher:start()

local frontApp = hs.application.frontmostApplication():name()
if appURLs[frontApp] then
  bindForApp(frontApp)
end