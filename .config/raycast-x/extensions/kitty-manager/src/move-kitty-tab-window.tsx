import { execSync } from "child_process";
import React from "react";
import { List, Action, ActionPanel, Icon, showToast, Toast } from "@raycast/api";

interface KittyWindow {
  id: number;
  title: string;
  tabs: number;
  is_active: boolean;
}

interface CurrentTab {
  os_window: number;
  tab_id: number;
}

function getKittySocket(): string | null {
  try {
    const pid = execSync("pgrep -f 'kitty.app/Contents/MacOS/kitty' | head -1", { encoding: "utf-8" }).trim();
    const socket = `/tmp/kitty-socket-${pid}`;
    try {
      execSync(`test -S ${socket}`);
      return socket;
    } catch {}
  } catch {}
  try {
    const sockets = execSync("ls /tmp/kitty-socket-* 2>/dev/null", { encoding: "utf-8" }).trim().split("\n").filter(Boolean);
    return sockets[0] || null;
  } catch {
    return null;
  }
}

function kittyAt(args: string): string {
  const socket = getKittySocket();
  const socketArg = socket ? `--to unix:${socket}` : "";
  return execSync(`kitty @ ${socketArg} ${args}`, { encoding: "utf-8" });
}

function getOsWindows(): KittyWindow[] {
  const data = JSON.parse(kittyAt("ls"));
  return data.map((w: any) => ({
    id: w.id,
    title: w.tabs.map((t: any) => t.title).filter(Boolean).join(", ") || "Empty",
    tabs: w.tabs.length,
    is_active: w.is_active,
  }));
}

function getCurrentTab(): CurrentTab | null {
  const data = JSON.parse(kittyAt("ls"));
  for (const w of data) {
    for (const t of w.tabs) {
      if (t.is_active) return { os_window: w.id, tab_id: t.id };
    }
  }
  return null;
}

function moveCurrentTabToWindow(targetWindowId: number) {
  const current = getCurrentTab();
  if (!current) throw new Error("No active tab found");
  const data = JSON.parse(kittyAt("ls"));
  const targetWin = data.find((w: any) => w.id === targetWindowId);
  if (!targetWin || !targetWin.tabs.length) throw new Error("Target window has no tabs");
  const targetTabId = targetWin.tabs[0].id;
  kittyAt(`detach-tab --match id:${current.tab_id} --target-tab id:${targetTabId}`);
}

export default function Command() {
  const [windows, setWindows] = React.useState<KittyWindow[]>([]);
  const [loading, setLoading] = React.useState(true);

  React.useEffect(() => {
    try {
      const wins = getOsWindows();
      const current = getCurrentTab();
      setWindows(wins.filter((w) => w.id !== current?.os_window));
      setLoading(false);
    } catch (e) {
      setLoading(false);
    }
  }, []);

  return (
    <List isLoading={loading}>
      {windows.map((win) => (
        <List.Item
          key={win.id}
          title={`Window ${win.id}`}
          subtitle={win.title}
          accessories={[{ text: `${win.tabs} tab${win.tabs > 1 ? "s" : ""}` }]}
          icon={Icon.Window}
          actions={
            <ActionPanel>
              <Action
                title="Move Tab Here"
                icon={Icon.ArrowRight}
                onAction={() => {
                  try {
                    moveCurrentTabToWindow(win.id);
                    showToast(Toast.Style.Success, "Tab moved!");
                  } catch (e) {
                    showToast(Toast.Style.Failure, "Failed to move tab", String(e));
                  }
                }}
              />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
