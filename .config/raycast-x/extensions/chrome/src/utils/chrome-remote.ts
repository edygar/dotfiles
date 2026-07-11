import { execFileSync } from "child_process";
import { existsSync, writeFileSync, mkdirSync } from "fs";
import { homedir } from "os";
import { join } from "path";
import type { ChromeWindow } from "./types";

const TIMEOUT = 15000;
const DELAY_ACTIVATE = 0.15;
const DELAY_RCLICK = 0.2;
const DELAY_TYPE = 0.1;
const DELAYER_SUBMENU = 0.15;
const APP_NAME = "Google Chrome";

const RCLICK_SOURCE = `
import Cocoa

let args = CommandLine.arguments
guard args.count >= 3, let x = Double(args[1]), let y = Double(args[2]) else {
    fputs("Usage: rclick <x> <y>\\n", stderr)
    exit(1)
}

let point = CGPoint(x: x, y: y)
let source = CGEventSource(stateID: .hidSystemState)

guard let move = CGEvent(mouseEventSource: source, mouseType: .mouseMoved, mouseCursorPosition: point, mouseButton: .right) else { exit(1) }
move.post(tap: .cghidEventTap)

guard let down = CGEvent(mouseEventSource: source, mouseType: .rightMouseDown, mouseCursorPosition: point, mouseButton: .right) else { exit(1) }
down.post(tap: .cghidEventTap)

usleep(50000)

guard let up = CGEvent(mouseEventSource: source, mouseType: .rightMouseUp, mouseCursorPosition: point, mouseButton: .right) else { exit(1) }
up.post(tap: .cghidEventTap)
`;

const RCLICK_BIN = join(
  homedir(),
  ".config",
  "raycast-x",
  "extensions",
  "chrome",
  "rclick",
);
const RCLICK_SRC = join(
  homedir(),
  ".config",
  "raycast-x",
  "extensions",
  "chrome",
  "rclick.swift",
);

function ensureRightClickBinary(): void {
  const sourceHash = execFileSync(
    "sh",
    ["-c", `echo '${RCLICK_SOURCE}' | shasum`],
    {
      encoding: "utf-8",
      timeout: 5000,
    },
  )
    .trim()
    .split(/\s+/)[0];
  const hashFile = `${RCLICK_BIN}.hash`;
  if (existsSync(RCLICK_BIN) && existsSync(hashFile)) {
    const existingHash = execFileSync("cat", [hashFile], {
      encoding: "utf-8",
      timeout: 2000,
    }).trim();
    if (existingHash === sourceHash) return;
  }
  mkdirSync(join(homedir(), ".config", "raycast-x", "extensions", "chrome"), {
    recursive: true,
  });
  writeFileSync(RCLICK_SRC, RCLICK_SOURCE);
  execFileSync("swiftc", ["-O", RCLICK_SRC, "-o", RCLICK_BIN], {
    timeout: 30000,
  });
  writeFileSync(hashFile, sourceHash);
}

function runJXA(script: string): string {
  return execFileSync("osascript", ["-l", "JavaScript", "-e", script], {
    encoding: "utf-8",
    timeout: TIMEOUT,
  }).trim();
}

function runAppleScript(script: string): string {
  return execFileSync("osascript", ["-e", script], {
    encoding: "utf-8",
    timeout: TIMEOUT,
  }).trim();
}

export function isChromeRunning(): boolean {
  try {
    execFileSync("pgrep", ["-x", "Google Chrome"], {
      encoding: "utf-8",
      timeout: 3000,
    });
    return true;
  } catch {
    return false;
  }
}

export function activateChrome(): void {
  execFileSync(
    "osascript",
    ["-e", `tell application "${APP_NAME}" to activate`],
    { timeout: 3000 },
  );
}

export function listWindows(): ChromeWindow[] {
  const script = `
    const chrome = Application("${APP_NAME}");
    const windows = chrome.windows();
    if (windows.length === 0) { JSON.stringify([]); }
    else {
      const result = windows.map((w, winIdx) => {
        const tabs = w.tabs();
        return {
          id: Number(w.id()),
          name: w.name(),
          activeTabIndex: w.activeTabIndex(),
          incognito: w.mode() === "incognito",
          isFrontmost: winIdx === 0,
          tabs: tabs.map((t, tabIdx) => ({
            index: tabIdx + 1,
            title: t.title(),
            url: t.url(),
            active: (tabIdx + 1) === w.activeTabIndex()
          }))
        };
      });
      JSON.stringify(result);
    }
  `;
  const result = runJXA(script);
  return JSON.parse(result) as ChromeWindow[];
}

function sanitizeForKeystroke(s: string): string {
  return s.replace(/\\/g, "\\\\").replace(/"/g, '\\"').substring(0, 20);
}

export function moveTabToWindow(
  sourceWinId: number,
  targetWinName: string,
): void {
  ensureRightClickBinary();
  const targetName = sanitizeForKeystroke(targetWinName);
  const script = `
tell application "${APP_NAME}"
  set sourceWinIdStr to "${sourceWinId}" as string
  repeat with w in windows
    set winIdStr to (id of w) as string
    if winIdStr is sourceWinIdStr then
      set index of w to 1
      exit repeat
    end if
  end repeat
  activate
end tell
delay ${DELAY_ACTIVATE}
tell application "System Events"
  tell process "${APP_NAME}"
    set winPos to position of window 1
    set winSize to size of window 1
    set winX to item 1 of winPos
    set winY to item 2 of winPos
    set winW to item 1 of winSize
  end tell
end tell
tell application "${APP_NAME}"
  set tabIndex to active tab index of window 1
  set tabCount to count of tabs of window 1
end tell
set tabStartX to winX + 70
set availWidth to winW - 100
set tabWidth to 240
if availWidth / tabCount < tabWidth then set tabWidth to availWidth / tabCount
if tabWidth < 40 then set tabWidth to 40
set tabX to (tabStartX + (tabIndex - 1) * tabWidth + tabWidth / 2) as integer
set tabY to (winY + 20) as integer
do shell script "${RCLICK_BIN} " & tabX & " " & tabY
delay ${DELAY_RCLICK}
tell application "System Events"
  keystroke "Move Tab"
  delay ${DELAY_TYPE}
  key code 36
  delay ${DELAYER_SUBMENU}
  keystroke "${targetName}"
  delay ${DELAY_TYPE}
  key code 36
end tell`;
  runAppleScript(script);
}

export function moveTabToNewWindow(): void {
  const script = `
tell application "${APP_NAME}" to activate
delay ${DELAY_ACTIVATE}
tell application "System Events"
  tell process "${APP_NAME}"
    click menu item "Move Tab to New Window" of menu "Tab" of menu bar item "Tab" of menu bar 1
  end tell
end tell`;
  runAppleScript(script);
}

export type ChromeError = "not_running" | "no_windows" | "unknown";

export function classifyError(error: unknown): ChromeError {
  if (!isChromeRunning()) return "not_running";
  const msg = error instanceof Error ? error.message : String(error);
  if (msg.includes("Can't get window") || msg.includes("doesn't understand"))
    return "no_windows";
  return "unknown";
}
