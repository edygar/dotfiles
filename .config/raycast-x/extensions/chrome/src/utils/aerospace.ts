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

const CHROME_SUFFIX = " - Google Chrome";

function getAerospaceChromeWindows(): { workspace: string; title: string }[] {
  const result: { workspace: string; title: string }[] = [];

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
    return result;
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
        if (
          w["app-name"] === "Google Chrome" &&
          w["window-title"].endsWith(CHROME_SUFFIX)
        ) {
          result.push({
            workspace: ws,
            title: w["window-title"].slice(0, -CHROME_SUFFIX.length),
          });
        }
      }
    } catch {
      // skip workspace on error
    }
  }

  return result;
}

export function getChromeWindowWorkspaceMap(
  chromeWindows: { id: number; name: string }[],
): Map<number, string> {
  const map = new Map<number, string>();
  if (!isAerospaceInstalled()) return map;

  const aeroWindows = getAerospaceChromeWindows();
  const usedAeroIndices = new Set<number>();

  for (const chromeWin of chromeWindows) {
    const idx = aeroWindows.findIndex(
      (a, i) => !usedAeroIndices.has(i) && a.title === chromeWin.name,
    );
    if (idx !== -1) {
      usedAeroIndices.add(idx);
      map.set(chromeWin.id, aeroWindows[idx].workspace);
    }
  }

  return map;
}
