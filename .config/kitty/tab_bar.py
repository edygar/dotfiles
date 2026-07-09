#!/usr/bin/env python3
from kitty.tab_bar import as_rgb, draw_title
from kitty.utils import color_as_int


def draw_tab(draw_data, screen, tab, before, max_tab_length, index, is_last, extra_data):
    bg = as_rgb(color_as_int("#181818"))
    accent = as_rgb(color_as_int("#729CD5"))
    white = as_rgb(color_as_int("#ffffff"))
    inactive_fg = as_rgb(color_as_int("#abb2bf"))

    title = tab.title
    if len(title) > max_tab_length:
        title = title[:max_tab_length - 1] + '…'
    num = str(index + 1)
    inner = f"{num}: {title}"

    if tab.is_active:
        # Left rounded: fg=accent, bg=terminal
        screen.cursor.fg = accent
        screen.cursor.bg = bg
        screen.draw("\ue0b6")
        # Content: fg=white, bg=accent
        screen.cursor.fg = white
        screen.cursor.bg = accent
        screen.draw(f" {inner} ")
        # Right rounded: fg=accent, bg=terminal
        screen.cursor.fg = accent
        screen.cursor.bg = bg
        screen.draw("\ue0b4")
    else:
        # Inactive: plain text
        screen.cursor.fg = inactive_fg
        screen.cursor.bg = bg
        screen.draw(f" {inner} ")

    # Gap
    screen.cursor.fg = inactive_fg
    screen.cursor.bg = bg
    screen.draw(" ")

    return screen.cursor.x
