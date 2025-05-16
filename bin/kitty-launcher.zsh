#!/usr/bin/env zsh
#
# kitty-launcher.zsh
#
# Usage:
#   ./kitty-launcher.zsh "<os-window-title>" "<tab-title>" "<shell-command>"
#
# Example:
#   ./kitty-launcher.zsh "Servers" "LLAMA" "llama-server -hf ggml-org/Qwen2.5-Coder-1.5B-Q8_0-GGUF --port 8012 -ngl 99 -fa -ub 1024 -b 1024 --ctx-size 0 --cache-reuse 256"
#
# This script launches the given shell command in a kitty OS‑window.
# If an OS‑window whose first tab’s title equals the provided <os-window-title>
# does not exist, the script creates one (running the command in its first tab) and exits.
#
# If it does exist, the script launches a new tab (with the given <tab-title>)
# in that OS‑window, then joins that tab into the target OS‑window’s first tab so that
# the two commands appear as split panes rather than separate tabs.
#
# The executed command is prefixed with echo messages (and an ANSI escape to set the terminal title)
# so that these messages appear inside the new kitty session.
#
# Requirements:
#   - kitty with remote-control enabled (and version 0.26+ for join-tab).
#   - jq installed (for parsing kitty’s JSON output).

# Verify that we have at least 3 parameters.
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <os-window-title> <tab-title> <shell-command>"
    exit 1
fi

# First parameter: the OS‑window title (we expect the first tab in that window to have this title).
os_window_title="$1"
# Second parameter: the new tab title.
tab_title="$2"
shift 2
# The rest forms the shell command to execute.
cmd="$@"

# Build the command string that will run in kitty.
# It sets the terminal (pane) title, echoes some info, then executes the given command.
final_command=". ~/.zprofile;
printf '\033]0;${tab_title}\007';
echo 'Launching in OS-window: ${os_window_title}';
echo 'Tab (split) title: ${tab_title}';
echo 'Command: ${cmd}';
echo '';
${cmd}"

# Helper function:
# Get the id of the first tab of an OS‑window whose first tab's title exactly matches the given OS‑window title.
get_target_tab_id() {
    kitty @ ls | jq -r --arg title "$1" '.[] | select(.tabs[0].title == $title) | .tabs[0].id' | head -n 1
}

# Helper function:
# Get the id of a tab within the OS‑window whose first tab's title matches the provided os_window_title
# and whose own title matches the given tab title.
get_new_tab_id() {
    kitty @ ls | jq -r --arg wtitle "$os_window_title" --arg ttitle "$1" '
      .[] | select(.tabs[0].title == $wtitle) | .tabs[] | select(.title == $ttitle) | .id' | head -n 1
}

# Try to locate the target OS‑window (by matching the first tab’s title).
target_tab_id=$(get_target_tab_id "$os_window_title")

if [ -z "$target_tab_id" ]; then
    echo "OS-window '$os_window_title' not found."
    echo "Creating a new OS-window with title '$os_window_title' and running the command there."
    kitty @ launch --hold --env BROWSER=none --dont-take-focus \
        --title "$os_window_title" --type=os-window --cwd=current \
        zsh -c "$final_command" &>/dev/null 2>&1 &
    # Exit after creating the OS‑window so the command runs only once.
    exit 0
fi

echo "OS-window '$os_window_title' exists (target tab id: $target_tab_id)."

# Launch the new command in a new tab (temporarily).
echo "Launching new tab with title '$tab_title' in OS-window '$os_window_title'."
kitty @ launch --hold --env BROWSER=none --dont-take-focus \
    --title "$tab_title" --match "id:$target_tab_id" --type=tab --cwd=current \
    zsh -c "$final_command" &>/dev/null 2>&1 &

# Give kitty a moment to create the new tab.
sleep 2

# Retrieve the id of the newly launched tab (which should have title equal to tab_title) in the target OS-window.
new_tab_id=$(get_new_tab_id "$tab_title")

if [ -z "$new_tab_id" ]; then
    echo "Error: Could not locate the newly launched tab with title '$tab_title'."
    exit 1
fi

echo "New tab launched (id: $new_tab_id). Joining it into target tab (id: $target_tab_id) as a split pane."

# Use kitty's join-tab command to merge the new tab into the target tab.
kitty @ join-tab --match "id:$new_tab_id" --target-tab "id:$target_tab_id" &>/dev/null 2>&1

# (Optionally, you could force a layout refresh here using 'kitty @ set-window-layout' if desired.)

exit 0
