#!/usr/bin/env python3
# Custom kitty tab bar with rounded active tab (pill shape)

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
    separator_fg = as_rgb(color_as_int("#3e4451"))

    # Tab number
    num = str(tab.index + 1)

    if tab.is_active:
        # Active: rounded pill shape with accent background
        yield ("╭", accent_bg, accent_bg)
        yield (f" {num}: {title} ", accent_fg, accent_bg)
        yield ("╮", accent_bg, accent_bg)
    else:
        # Inactive: no background, just text
        yield (f" {num}: {title} ", inactive_fg, bg)

    # Separator between tabs
    yield (" ", inactive_fg, bg)
