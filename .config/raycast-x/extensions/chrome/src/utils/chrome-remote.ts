import { execFileSync } from "child_process";
import { appendFileSync } from "fs";
import type { ChromeWindow } from "./types";

const TIMEOUT = 10000;
const APP_NAME = "Google Chrome";
const LOG_PATH = "/tmp/raycast-chrome-move-tab.log";

function logFailure(action: string, error: unknown): void {
  const err = error as { stdout?: Buffer; stderr?: Buffer; message?: string };
  appendFileSync(
    LOG_PATH,
    [
      `[${new Date().toISOString()}] ${action}`,
      err.message || String(error),
      err.stdout ? `stdout: ${err.stdout.toString()}` : "",
      err.stderr ? `stderr: ${err.stderr.toString()}` : "",
      "",
    ].join("\n"),
  );
}

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
  targetTitle: string,
  targetFullTitle: string,
  targetTabCount: number,
): void {
  const luaTargetTitle = JSON.stringify(targetTitle);
  const luaTargetFullTitle = JSON.stringify(targetFullTitle);
  try {
    execFileSync(
      "/opt/homebrew/bin/hs",
      [
        "-c",
        `package.loaded["chrome-move-tab"] = nil; require("chrome-move-tab").doMoveToWindow(${sourceWinId}, ${targetWinId}, ${luaTargetTitle}, ${luaTargetFullTitle}, ${targetTabCount})`,
      ],
      { timeout: TIMEOUT },
    );
  } catch (error) {
    logFailure(`moveTabToWindow ${sourceWinId} -> ${targetWinId} (${targetTitle} / ${targetFullTitle} / ${targetTabCount})`, error);
    throw error;
  }
}

export function moveTabToNewWindow(): void {
  try {
    execFileSync(
      "/opt/homebrew/bin/hs",
      [
        "-c",
        `package.loaded["chrome-move-tab"] = nil; require("chrome-move-tab").doMoveToNewWindow()`,
      ],
      { timeout: TIMEOUT },
    );
  } catch (error) {
    logFailure("moveTabToNewWindow", error);
    throw error;
  }
}

export type ChromeError = "not_running" | "no_windows" | "unknown";

export function classifyError(error: unknown): ChromeError {
  if (!isChromeRunning()) return "not_running";
  const msg = error instanceof Error ? error.message : String(error);
  if (msg.includes("Can't get window") || msg.includes("doesn't understand"))
    return "no_windows";
  return "unknown";
}
