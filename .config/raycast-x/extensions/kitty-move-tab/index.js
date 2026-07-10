"use strict";
const React = require("react");
const { List, Action, ActionPanel, Icon, showToast, Toast } = require("@raycast/api");
const { getOsWindows, getCurrentTab, moveCurrentTabToWindow } = require("./kitty");

function Command() {
  const [windows, setWindows] = React.useState([]);
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

  return React.createElement(
    List,
    { isLoading: loading },
    windows.map((win) =>
      React.createElement(List.Item, {
        key: win.id,
        title: `Window ${win.id}`,
        subtitle: win.title,
        accessories: [{ text: `${win.tabs} tab${win.tabs > 1 ? "s" : ""}` }],
        icon: Icon.Window,
        actions: React.createElement(
          ActionPanel,
          null,
          React.createElement(Action, {
            title: "Move Tab Here",
            icon: Icon.ArrowRight,
            onAction: () => {
              try {
                moveCurrentTabToWindow(win.id);
                showToast(Toast.Style.Success, "Tab moved!");
              } catch (e) {
                showToast(Toast.Style.Failure, "Failed to move tab", String(e));
              }
            },
          })
        ),
      })
    )
  );
}

module.exports = { default: Command };
