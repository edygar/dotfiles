"use strict";
const { execSync } = require("child_process");

function getKittySocket() {
  try {
    const pid = execSync("pgrep -f 'kitty.app/Contents/MacOS/kitty' | head -1", { encoding: "utf-8" }).trim();
    const socket = `/tmp/kitty-socket-${pid}`;
    try { execSync(`test -S ${socket}`); return socket; } catch {}
  } catch {}
  try {
    const sockets = execSync("ls /tmp/kitty-socket-* 2>/dev/null", { encoding: "utf-8" }).trim().split("\n").filter(Boolean);
    return sockets[0] || null;
  } catch { return null; }
}

function kittyAt(args) {
  const socket = getKittySocket();
  const socketArg = socket ? `--to unix:${socket}` : "";
  return execSync(`kitty @ ${socketArg} ${args}`, { encoding: "utf-8" });
}

function getOsWindows() {
  const data = JSON.parse(kittyAt("ls"));
  return data.map((w) => ({
    id: w.id,
    title: w.tabs.map((t) => t.title).filter(Boolean).join(", ") || "Empty",
    tabs: w.tabs.length,
    is_active: w.is_active,
  }));
}

function getCurrentTab() {
  const data = JSON.parse(kittyAt("ls"));
  for (const w of data) {
    for (const t of w.tabs) {
      if (t.is_active) return { os_window: w.id, tab_id: t.id };
    }
  }
  return null;
}

function moveCurrentTabToWindow(targetWindowId) {
  const current = getCurrentTab();
  if (!current) throw new Error("No active tab found");
  const data = JSON.parse(kittyAt("ls"));
  const targetWin = data.find((w) => w.id === targetWindowId);
  if (!targetWin || !targetWin.tabs.length) throw new Error("Target window has no tabs");
  const targetTabId = targetWin.tabs[0].id;
  kittyAt(`detach-tab --match id:${current.tab_id} --target-tab id:${targetTabId}`);
}

module.exports = { getOsWindows, getCurrentTab, moveCurrentTabToWindow };
