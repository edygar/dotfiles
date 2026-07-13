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

export function moveTabToWindow(
  sourceWinId: number,
  targetWinId: number,
): void {
  execFileSync(
    "/opt/homebrew/bin/hs",
    [
      "-c",
      `require("chrome-move-tab").doMoveToWindow(${sourceWinId}, ${targetWinId})`,
    ],
    { timeout: TIMEOUT },
  );
}

export function moveTabToNewWindow(): void {
  execFileSync(
    "/opt/homebrew/bin/hs",
    ["-c", `require("chrome-move-tab").doMoveToNewWindow()`],
    { timeout: TIMEOUT },
  );
}

export type ChromeError = "not_running" | "no_windows" | "unknown";

export function classifyError(error: unknown): ChromeError {
  if (!isChromeRunning()) return "not_running";
  const msg = error instanceof Error ? error.message : String(error);
  if (msg.includes("Can't get window") || msg.includes("doesn't understand"))
    return "no_windows";
  return "unknown";
}
