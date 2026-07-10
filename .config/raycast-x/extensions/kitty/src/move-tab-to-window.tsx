import {
  Action,
  ActionPanel,
  Icon,
  List,
  showToast,
  Toast,
  popToRoot,
} from "@raycast/api";
import { useState, useEffect } from "react";
import {
  isKittyRunning,
  isSocketAvailable,
  listAll,
  detachTab,
  detachTabToNewWindow,
  focusTab,
  focusWindow,
  activateKitty,
  classifyError,
} from "./utils/kitty-remote";
import { getWindowWorkspaceMap } from "./utils/aerospace";
import { SetupGuide } from "./utils/components";
import type { KittyOSWindow, KittyTab } from "./utils/types";

/** Re-fetch all windows and find a tab by its (possibly stale) ID. */
function findTabById(
  osWindows: KittyOSWindow[],
  tabId: number,
): { osWindow: KittyOSWindow; tab: KittyTab } | null {
  for (const osWin of osWindows) {
    const tab = osWin.tabs.find((t) => t.id === tabId);
    if (tab) return { osWindow: osWin, tab };
  }
  return null;
}

interface TargetWindow {
  osWindowId: number;
  focusedTab: KittyTab;
  tabCount: number;
  isFocused: boolean;
  workspace?: string;
}

function findFocusedTab(
  osWindows: KittyOSWindow[],
): { osWindowId: number; tab: KittyTab } | null {
  // When Raycast is in the foreground, kitty loses OS focus and
  // is_focused is False on everything. Use is_active (which kitty
  // keeps set to the last active tab/window) as the primary signal.
  // Prefer the OS window with last_focused or is_focused, then
  // find the active tab within it.
  const sorted = [...osWindows].sort((a, b) => {
    const aRank = a.is_focused ? 2 : a.last_focused ? 1 : 0;
    const bRank = b.is_focused ? 2 : b.last_focused ? 1 : 0;
    return bRank - aRank;
  });

  for (const osWin of sorted) {
    const tab =
      osWin.tabs.find((t) => t.is_focused) ||
      osWin.tabs.find((t) => t.is_active);
    if (tab) {
      return { osWindowId: osWin.id, tab };
    }
  }

  const firstWin = osWindows[0];
  if (firstWin?.tabs.length) {
    return { osWindowId: firstWin.id, tab: firstWin.tabs[0] };
  }
  return null;
}

function getOtherWindows(
  osWindows: KittyOSWindow[],
  currentOsWindowId: number,
  workspaceMap: Map<number, string>,
): TargetWindow[] {
  return osWindows
    .filter((osWin) => osWin.id !== currentOsWindowId)
    .map((osWin) => {
      const focusedTab =
        osWin.tabs.find((t) => t.is_focused || t.is_active) || osWin.tabs[0];
      const workspace = osWin.platform_window_id
        ? workspaceMap.get(osWin.platform_window_id)
        : undefined;
      return {
        osWindowId: osWin.id,
        focusedTab,
        tabCount: osWin.tabs.length,
        isFocused: osWin.is_focused,
        workspace,
      };
    });
}

export default function Command() {
  const [windows, setWindows] = useState<TargetWindow[]>([]);
  const [currentTab, setCurrentTab] = useState<{
    osWindowId: number;
    tab: KittyTab;
    workspace?: string;
  } | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [showSetup, setShowSetup] = useState(false);

  const loadWindows = async () => {
    setIsLoading(true);
    try {
      if (!isKittyRunning()) {
        setWindows([]);
        setIsLoading(false);
        await showToast({
          style: Toast.Style.Failure,
          title: "Kitty is not running",
        });
        return;
      }
      if (!isSocketAvailable()) {
        setShowSetup(true);
        setIsLoading(false);
        return;
      }
      const osWindows = listAll();
      const workspaceMap = getWindowWorkspaceMap();
      const focused = findFocusedTab(osWindows);
      if (!focused) {
        setWindows([]);
        setIsLoading(false);
        await showToast({
          style: Toast.Style.Failure,
          title: "No focused tab found",
        });
        return;
      }
      const focusedOsWin = osWindows.find((w) => w.id === focused.osWindowId);
      const currentWorkspace = focusedOsWin?.platform_window_id
        ? workspaceMap.get(focusedOsWin.platform_window_id)
        : undefined;
      setCurrentTab({ ...focused, workspace: currentWorkspace });
      setWindows(getOtherWindows(osWindows, focused.osWindowId, workspaceMap));
    } catch (error) {
      const kind = classifyError(error);
      if (kind === "no_socket" || kind === "remote_disabled") {
        setShowSetup(true);
      } else {
        await showToast({
          style: Toast.Style.Failure,
          title: "Failed to list windows",
          message: String(error),
        });
      }
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadWindows();
  }, []);

  if (showSetup) {
    return <SetupGuide />;
  }

  return (
    <List
      isLoading={isLoading}
      searchBarPlaceholder="Choose a Kitty window to move the current tab to..."
    >
      {windows.length === 0 && !isLoading && !currentTab ? (
        <List.EmptyView
          title="No other windows found"
          description="Open another Kitty window first"
        />
      ) : (
        <List.Section title="Target Windows">
          {currentTab && (
            <List.Item
              key="new-window"
              title="New Window"
              subtitle="Detach tab into a new OS window"
              icon={Icon.Plus}
              actions={
                <ActionPanel>
                  <Action
                    title="Move Tab to New Window"
                    icon={Icon.Plus}
                    onAction={async () => {
                      if (!currentTab) return;
                      try {
                        const freshWindows = listAll();

                        const source = findTabById(
                          freshWindows,
                          currentTab.tab.id,
                        );
                        if (!source) {
                          await showToast({
                            style: Toast.Style.Failure,
                            title: "Tab no longer exists",
                            message: "Please refresh and try again",
                          });
                          await loadWindows();
                          return;
                        }

                        const originalOsWindowIds = new Set(
                          freshWindows.map((w) => w.id),
                        );

                        detachTabToNewWindow(source.tab.id);

                        const postMoveWindows = listAll();
                        const newOsWin = postMoveWindows.find(
                          (w) => !originalOsWindowIds.has(w.id),
                        );
                        const movedTab = newOsWin?.tabs[0];

                        if (movedTab) {
                          focusTab(movedTab.id);
                        }

                        await popToRoot();
                        activateKitty();
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
              key={win.osWindowId}
              title={`Window ${win.osWindowId}`}
              subtitle={win.focusedTab.title}
              accessories={[
                ...(win.workspace ? [{ text: `Space ${win.workspace}` }] : []),
                { text: `${win.tabCount} tab${win.tabCount > 1 ? "s" : ""}` },
                ...(win.isFocused
                  ? [{ icon: Icon.Eye, tooltip: "Focused" }]
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
                        const freshWindows = listAll();

                        const source = findTabById(
                          freshWindows,
                          currentTab.tab.id,
                        );
                        if (!source) {
                          await showToast({
                            style: Toast.Style.Failure,
                            title: "Tab no longer exists",
                            message: "Please refresh and try again",
                          });
                          await loadWindows();
                          return;
                        }

                        const targetOsWin = freshWindows.find(
                          (w) => w.id === win.osWindowId,
                        );
                        if (!targetOsWin || !targetOsWin.tabs.length) {
                          await showToast({
                            style: Toast.Style.Failure,
                            title: "Target window no longer exists",
                            message: "Please refresh and try again",
                          });
                          await loadWindows();
                          return;
                        }

                        const targetTab =
                          targetOsWin.tabs.find(
                            (t) => t.id === win.focusedTab.id,
                          ) || targetOsWin.tabs[0];

                        const originalTargetTabIds = new Set(
                          targetOsWin.tabs.map((t) => t.id),
                        );

                        detachTab(source.tab.id, targetTab.id);

                        const postMoveWindows = listAll();
                        const postMoveTargetWin = postMoveWindows.find(
                          (w) => w.id === win.osWindowId,
                        );
                        const movedTab = postMoveTargetWin?.tabs.find(
                          (t) => !originalTargetTabIds.has(t.id),
                        );

                        if (movedTab) {
                          focusTab(movedTab.id);
                          if (movedTab.windows[0]) {
                            focusWindow(movedTab.windows[0].id);
                          }
                        }

                        await popToRoot();
                        activateKitty();
                        await showToast({
                          style: Toast.Style.Success,
                          title: "Tab moved",
                          message: `Moved to Window ${win.osWindowId}`,
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
                    shortcut={{ modifiers: ["cmd"], key: "r" }}
                    onAction={loadWindows}
                  />
                </ActionPanel>
              }
            />
          ))}
        </List.Section>
      )}
    </List>
  );
}
