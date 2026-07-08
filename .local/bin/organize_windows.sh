#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Organize Windows with AeroSpace
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🪟
# @raycast.packageName AeroSpace Window Manager
# @raycast.description Organizes Chrome to workspace 'a', Kitty to workspace 'b', and Slack/WhatsApp as tiles on workspace 'd'
# @raycast.author Your Name
# @raycast.authorURL https://raycast.com/

# Documentation:
# @raycast.needsConfirmation false

# AeroSpace Window Organization Script
# Organizes Chrome, Kitty, Slack, and WhatsApp across different workspaces

echo "🪟 Organizing windows with AeroSpace..."

# Function to move all windows of a specific app to a workspace
move_app_to_workspace() {
    local app_name="$1"
    local workspace="$2"
    
    echo "📱 Moving $app_name windows to workspace $workspace..."
    
    # Get all window IDs for the specified app
    aerospace list-windows --all | grep -i "$app_name" | while read -r line; do
        # Extract window ID (first column)
        window_id=$(echo "$line" | awk '{print $1}')
        if [[ -n "$window_id" ]]; then
            aerospace move-node-to-workspace --window-id "$window_id" "$workspace" 1>/dev/null 2>/dev/null
            echo "aerospace move-node-to-workspace --window-id \"$window_id\" \"$workspace\" 1>/dev/null 2>/dev/null"
        fi
    done
}

# Step 1: Bring all windows to workspace A
echo "🔄 Moving all windows to workspace A..."
aerospace list-windows --all | while read -r line; do
    window_id=$(echo "$line" | awk '{print $1}')
    if [[ -n "$window_id" ]]; then
        aerospace move-node-to-workspace --window-id "$window_id" "A" 1>/dev/null 2>/dev/null
        debug_echo "aerospace move-node-to-workspace --window-id \"$window_id\" \"A\""
    fi
done

# Step 2: Switch to workspace A and flatten the tree
echo "🔄 Flattening workspace tree..."
aerospace workspace A
debug_echo "aerospace workspace A"

aerospace flatten-workspace-tree
debug_echo "aerospace flatten-workspace-tree"

# Step 3: Now move applications to their respective workspaces
echo "🔄 Moving applications to their final workspaces..."

# Move all Chrome windows to workspace 'A' (they're already there, but let's be explicit)
move_app_to_workspace "Google Chrome" "A"
move_app_to_workspace "Chrome" "A"

# Move Kitty to workspace 'S'
move_app_to_workspace "kitty" "S"

# Move Slack and WhatsApp to workspace 'D'
move_app_to_workspace "Slack" "D"
move_app_to_workspace "WhatsApp" "D"

# Switch to workspace 'D' and set up the tiled layout for Slack and WhatsApp
echo "🔄 Setting up tiled layout for Slack and WhatsApp on workspace D..."
aerospace workspace D
debug_echo "aerospace workspace D"

# Get window IDs for Slack and WhatsApp on workspace D
slack_window=$(aerospace list-windows --workspace D | grep -i "slack" | head -1 | awk '{print $1}')
whatsapp_window=$(aerospace list-windows --workspace D | grep -i "whatsapp" | head -1 | awk '{print $1}')

debug_echo "Slack window ID: $slack_window"
debug_echo "WhatsApp window ID: $whatsapp_window"

# Focus on Slack first
if [[ -n "$slack_window" ]]; then
    aerospace focus --window-id "$slack_window"
    debug_echo "aerospace focus --window-id \"$slack_window\""
fi

# Set up horizontal split for the container
aerospace split horizontal
debug_echo "aerospace split horizontal"

# Focus on WhatsApp to ensure both windows are visible
if [[ -n "$whatsapp_window" ]]; then
    aerospace focus --window-id "$whatsapp_window"
    debug_echo "aerospace focus --window-id \"$whatsapp_window\""
fi

# Set layout to tiles
aerospace layout tiles
debug_echo "aerospace layout tiles"

echo "✅ Window organization complete!"
echo "🌐 Chrome windows: workspace 'A'"
echo "💻 Kitty: workspace 'S'"
echo "💬 Slack & WhatsApp: workspace 'D' (tiled)"

# Show window counts for verification
if [[ "$DEBUG" == "true" ]]; then
    echo ""
    echo "📊 Window counts per workspace:"
    echo "Workspace A: $(aerospace list-windows --workspace A | wc -l) windows"
    echo "Workspace S: $(aerospace list-windows --workspace S | wc -l) windows"
    echo "Workspace D: $(aerospace list-windows --workspace D | wc -l) windows"
fi
