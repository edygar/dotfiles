import { execFileSync } from "child_process";

const TIMEOUT = 5000;

interface AerospaceWindow {
  "app-name": string;
  "window-id": number;
  "window-title": string;
}

function isAerospaceInstalled(): boolean {
  try {
    execFileSync("which", ["aerospace"], {
      encoding: "utf-8",
      timeout: 2000,
    });
    return true;
  } catch {
    return false;
  }
}

/** Build a map of macOS window-id → Aerospace workspace name */
export function getWindowWorkspaceMap(): Map<number, string> {
  const map = new Map<number, string>();

  if (!isAerospaceInstalled()) return map;

  let workspaces: string[];
  try {
    workspaces = execFileSync("aerospace", ["list-workspaces", "--all"], {
      encoding: "utf-8",
      timeout: TIMEOUT,
    })
      .trim()
      .split("\n")
      .filter(Boolean);
  } catch {
    return map;
  }

  for (const ws of workspaces) {
    try {
      const raw = execFileSync(
        "aerospace",
        ["list-windows", "--workspace", ws, "--json"],
        { encoding: "utf-8", timeout: TIMEOUT },
      );
      const windows = JSON.parse(raw) as AerospaceWindow[];
      for (const w of windows) {
        map.set(w["window-id"], ws);
      }
    } catch {
      // skip workspace on error
    }
  }

  return map;
}
