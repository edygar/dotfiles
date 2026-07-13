import {
  Action,
  ActionPanel,
  Icon,
  List,
  showToast,
  Toast,
  closeMainWindow,
  Keyboard,
} from "@raycast/api";
import { useState, useEffect } from "react";
import {
  isChromeRunning,
  listWindows,
  moveTabToWindow,
  moveTabToNewWindow,
  activateChrome,
  classifyError,
} from "./utils/chrome-remote";
import { getChromeWindowWorkspaceMap, focusWorkspace } from "./utils/aerospace";
import type { ChromeWindow, ChromeTab } from "./utils/types";

interface TargetWindow {
  winId: number;
  title: string;
  activeTab: ChromeTab;
  tabCount: number;
  isFrontmost: boolean;
  incognito: boolean;
  workspace?: string;
}

function findFrontmostWindow(windows: ChromeWindow[]): ChromeWindow | null {
  return windows.find((w) => w.isFrontmost) || windows[0] || null;
}

function getOtherWindows(
  windows: ChromeWindow[],
  currentWinId: number,
  workspaceMap: Map<number, string>,
): TargetWindow[] {
  return windows
    .filter((w) => w.id !== currentWinId)
    .map((w) => {
      const activeTab = w.tabs[w.activeTabIndex - 1] || w.tabs[0];
      const workspace = workspaceMap.get(w.id);
      return {
        winId: w.id,
        title: w.name,
        activeTab,
        tabCount: w.tabs.length,
        isFrontmost: w.isFrontmost,
        incognito: w.incognito,
        workspace,
      };
    });
}

export default function Command() {
  const [windows, setWindows] = useState<TargetWindow[]>([]);
  const [currentTab, setCurrentTab] = useState<{
    winId: number;
    tabIndex: number;
    tab: ChromeTab;
    workspace?: string;
  } | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  const loadWindows = async () => {
    setIsLoading(true);
    try {
      if (!isChromeRunning()) {
        setWindows([]);
        setIsLoading(false);
        await showToast({
          style: Toast.Style.Failure,
          title: "Google Chrome is not running",
        });
        return;
      }
      const chromeWindows = listWindows();
      if (chromeWindows.length === 0) {
        setWindows([]);
        setIsLoading(false);
        await showToast({
          style: Toast.Style.Failure,
          title: "No Chrome windows found",
        });
        return;
      }
      const workspaceMap = getChromeWindowWorkspaceMap(
        chromeWindows.map((w) => ({ id: w.id, name: w.name })),
      );
      const frontmost = findFrontmostWindow(chromeWindows);
      if (!frontmost) {
        setWindows([]);
        setIsLoading(false);
        return;
      }
      const activeTab =
        frontmost.tabs[frontmost.activeTabIndex - 1] || frontmost.tabs[0];
      const currentWorkspace = workspaceMap.get(frontmost.id);
      setCurrentTab({
        winId: frontmost.id,
        tabIndex: activeTab.index,
        tab: activeTab,
        workspace: currentWorkspace,
      });
      setWindows(getOtherWindows(chromeWindows, frontmost.id, workspaceMap));
    } catch (error) {
      const kind = classifyError(error);
      await showToast({
        style: Toast.Style.Failure,
        title:
          kind === "not_running"
            ? "Google Chrome is not running"
            : "Failed to list windows",
        message: String(error),
      });
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadWindows();
  }, []);

  return (
    <List
      isLoading={isLoading}
      searchBarPlaceholder="Choose a Chrome window to move the current tab to..."
    >
      {windows.length === 0 && !isLoading && !currentTab ? (
        <List.EmptyView
          title="No other windows found"
          description="Open another Chrome window first"
        />
      ) : (
        <>
          <List.Section title="Target Windows">
            {currentTab && (
              <List.Item
                key="new-window"
                title="New Window"
                subtitle="Move tab into a new Chrome window"
                icon={Icon.Plus}
                actions={
                  <ActionPanel>
                    <Action
                      title="Move Tab to New Window"
                      icon={Icon.Plus}
                      onAction={async () => {
                        if (!currentTab) return;
                        try {
                          moveTabToNewWindow();
                          await closeMainWindow({ clearRootSearch: true });
                          activateChrome();
                          await showToast({
                            style: Toast.Style.Success,
                            title: "Tab moved to new window",
                          });
                        } catch (error) {
                          await showToast({
                            style: Toast.Style.Failure,
                            title: "Failed to move tab",
                            message: String(error),
                          });
                        }
                      }}
                    />
                  </ActionPanel>
                }
              />
            )}
            {windows.map((win) => (
              <List.Item
                key={win.winId}
                title={win.workspace ? `Space ${win.workspace}` : "Window"}
                subtitle={win.activeTab.title}
                accessories={[
                  { text: `${win.tabCount} tab${win.tabCount > 1 ? "s" : ""}` },
                  ...(win.incognito
                    ? [{ icon: Icon.EyeDisabled, tooltip: "Incognito" }]
                    : []),
                  ...(win.isFrontmost
                    ? [{ icon: Icon.Eye, tooltip: "Frontmost" }]
                    : []),
                ]}
                icon={Icon.Window}
                actions={
                  <ActionPanel>
                    <Action
                      title="Move Tab to This Window"
                      icon={Icon.ArrowRight}
                      onAction={async () => {
                        if (!currentTab) return;
                        try {
                          moveTabToWindow(
                            currentTab.winId,
                            win.winId,
                            win.title,
                            win.activeTab.title,
                            win.tabCount,
                          );
                          await closeMainWindow({ clearRootSearch: true });
                          if (win.workspace) {
                            try {
                              focusWorkspace(win.workspace);
                            } catch {
                              // workspace focus is best-effort
                            }
                          }
                          activateChrome();
                          await showToast({
                            style: Toast.Style.Success,
                            title: "Tab moved",
                            message: `Moved to "${win.activeTab.title.slice(0, 40)}"`,
                          });
                        } catch (error) {
                          await showToast({
                            style: Toast.Style.Failure,
                            title: "Failed to move tab",
                            message: String(error),
                          });
                        }
                      }}
                    />
                    <Action
                      title="Refresh"
                      icon={Icon.ArrowClockwise}
                      shortcut={Keyboard.Shortcut.Common.Refresh}
                      onAction={loadWindows}
                    />
                  </ActionPanel>
                }
              />
            ))}
          </List.Section>
          {currentTab && (
            <List.Section title="Current Tab">
              <List.Item
                key="current-tab"
                title={
                  currentTab.workspace
                    ? `Space ${currentTab.workspace}`
                    : "\u2014"
                }
                subtitle={currentTab.tab.title}
                icon={Icon.ArrowDown}
              />
            </List.Section>
          )}
        </>
      )}
    </List>
  );
}
