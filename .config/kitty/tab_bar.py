#!/usr/bin/env python3
# Custom kitty tab bar with powerline rounded tab (pill shape)

from kitty.tab_bar import as_rgb
from kitty.utils import color_as_int


def draw_tab(tab, max_tab_length):
    min_tab_length = 1
    max_tab_length = 30
    if max_tab_length < min_tab_length:
        max_tab_length = min_tab_length

    # Tab title
    title = tab.title
    if len(title) > max_tab_length:
        title = title[:max_tab_length - 1] + '…'

    # Colors
    bg = as_rgb(color_as_int("#181818"))
    accent = as_rgb(color_as_int("#729CD5"))
    white = as_rgb(color_as_int("#ffffff"))
    inactive_fg = as_rgb(color_as_int("#abb2bf"))

    # Tab number
    num = str(tab.index + 1)

    if tab.is_active:
        # Active:  (left half circle) + content +  (right half circle)
        # Left rounded: fg=accent, bg=terminal_bg
        yield ("\ue0b6", accent, bg)
        # Content: fg=white, bg=accent
        yield (f" {num}: {title} ", white, accent)
        # Right rounded: fg=accent, bg=terminal_bg
        yield ("\ue0b4", accent, bg)
    else:
        # Inactive: plain text, no background
        yield (f" {num}: {title} ", inactive_fg, bg)

    # Gap between tabs
    yield (" ", inactive_fg, bg)
