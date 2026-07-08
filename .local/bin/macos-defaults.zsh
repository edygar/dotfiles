#!/usr/bin/env zsh
#
# macos-defaults.zsh
#
# Sets macOS system preferences/defaults.
# Run this after a fresh install to configure the system.
#
# Usage: macos-defaults.zsh

echo "Setting macOS defaults..."

# Dock
echo "  Dock: autohide, no delay"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

# Menu bar
echo "  Menu bar: auto-hide"
defaults write com.apple.dock autohide-menubar -bool true
defaults write com.apple.dock autohide-menubar-fullscreen -bool true

# Finder
echo "  Finder: show hidden files, list view, path bar"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Keyboard
echo "  Keyboard: fast key repeat, no auto-correct"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Trackpad
echo "  Trackpad: tap to click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Screenshot
echo "  Screenshot: no shadow, specific location"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Window
echo "  Windows: minimize on double-click title bar"
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool true

# Activity Monitor
echo "  Activity Monitor: sort by CPU"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Restart affected services
echo "  Restarting services..."
killall Dock 2>/dev/null
killall Finder 2>/dev/null
killall SystemUIServer 2>/dev/null

echo "macOS defaults set."
