import { execFileSync } from "child_process";
import type { ChromeWindow } from "./types";

const TIMEOUT = 10000;
const APP_NAME = "Google Chrome";

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

export function moveTabToWindow(targetWinId: number): void {
  const script = `
tell application "${APP_NAME}"
  set targetWinIdStr to "${targetWinId}" as string

  set sourceWin to window 1
  set targetWin to missing value
  repeat with w in windows
    set winIdStr to (id of w) as string
    if winIdStr is targetWinIdStr then set targetWin to w
  end repeat

  if targetWin is missing value then error "Target window not found"

  set tabURL to URL of active tab of sourceWin
  make new tab at end of tabs of targetWin with properties {URL:tabURL}
  set active tab index of targetWin to (count of tabs of targetWin)
  close active tab of sourceWin
end tell`;
  runAppleScript(script);
}

export function moveTabToNewWindow(): void {
  const script = `
tell application "${APP_NAME}"
  set sourceWin to window 1

  set tabURL to URL of active tab of sourceWin
  set newWin to make new window
  set URL of active tab of newWin to tabURL
  close active tab of sourceWin
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
