#!/usr/bin/env python3
# Custom kitty tab bar with rounded active tab

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
    accent_bg = as_rgb(color_as_int("#729CD5"))
    accent_fg = as_rgb(color_as_int("#ffffff"))
    inactive_fg = as_rgb(color_as_int("#abb2bf"))

    # Tab number
    num = str(tab.index + 1)
    inner = f" {num}: {title} "

    if tab.is_active:
        # Active: rounded corners on both sides, accent background filling the whole tab
        yield ("╭", accent_bg, accent_bg)
        yield ("─", accent_bg, accent_bg)
        yield (inner, accent_fg, accent_bg)
        yield ("─", accent_bg, accent_bg)
        yield ("╮", accent_bg, accent_bg)
    else:
        # Inactive: plain text, no background
        yield (inner, inactive_fg, bg)

    # Gap between tabs
    yield (" ", inactive_fg, bg)
