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

function getAerospaceChromeWindows(): {
  workspace: string;
  title: string;
}[] {
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

function getSystemEventsChromeTitles(): Map<number, string> {
  const script = `
    const sys = Application("System Events");
    const proc = sys.processes.byName("Google Chrome");
    const wins = proc.windows();
    const result = [];
    for (let i = 0; i < wins.length; i++) {
      try {
        const w = wins[i];
        const subrole = w.subrole();
        if (subrole === "AXStandardWindow" || subrole === "AXDialog") {
          result.push({ index: i, title: w.name() });
        }
      } catch(e) {}
    }
    JSON.stringify(result);
  `;
  try {
    const raw = execFileSync("osascript", ["-l", "JavaScript", "-e", script], {
      encoding: "utf-8",
      timeout: TIMEOUT,
    }).trim();
    const entries = JSON.parse(raw) as { index: number; title: string }[];
    const map = new Map<number, string>();
    for (const e of entries) {
      map.set(e.index, e.title);
    }
    return map;
  } catch {
    return new Map();
  }
}

export function getChromeWindowWorkspaceMap(
  chromeWindows: { id: number; name: string }[],
): Map<number, string> {
  const map = new Map<number, string>();
  if (!isAerospaceInstalled()) return map;

  const aeroWindows = getAerospaceChromeWindows();

  const seTitles = getSystemEventsChromeTitles();
  const seTitleList = [...seTitles.values()];

  const usedAeroIndices = new Set<number>();
  const usedSEIndices = new Set<number>();

  for (let i = 0; i < chromeWindows.length; i++) {
    const chromeWin = chromeWindows[i];
    const seTitle = seTitles.get(i);

    if (seTitle) {
      const idx = aeroWindows.findIndex(
        (a, j) => !usedAeroIndices.has(j) && a.title === seTitle,
      );
      if (idx !== -1) {
        usedAeroIndices.add(idx);
        map.set(chromeWin.id, aeroWindows[idx].workspace);
        continue;
      }
    }

    const seIdx = seTitleList.findIndex(
      (t, j) =>
        !usedSEIndices.has(j) &&
        chromeWin.name.length > 0 &&
        t.includes(chromeWin.name),
    );
    if (seIdx !== -1) {
      usedSEIndices.add(seIdx);
      const fullTitle = seTitleList[seIdx];
      const aeroIdx = aeroWindows.findIndex(
        (a, j) => !usedAeroIndices.has(j) && a.title === fullTitle,
      );
      if (aeroIdx !== -1) {
        usedAeroIndices.add(aeroIdx);
        map.set(chromeWin.id, aeroWindows[aeroIdx].workspace);
        continue;
      }
    }

    const aeroIdx = aeroWindows.findIndex(
      (a, j) => !usedAeroIndices.has(j) && a.title === chromeWin.name,
    );
    if (aeroIdx !== -1) {
      usedAeroIndices.add(aeroIdx);
      map.set(chromeWin.id, aeroWindows[aeroIdx].workspace);
    }
  }

  return map;
}
