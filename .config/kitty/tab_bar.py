#!/usr/bin/env python3
from kitty.tab_bar import as_rgb
from kitty.utils import color_as_int

def draw_tab(tab, max_tab_length):
    bg = as_rgb(color_as_int("#181818"))
    accent = as_rgb(color_as_int("#729CD5"))
    white = as_rgb(color_as_int("#ffffff"))
    inactive_fg = as_rgb(color_as_int("#abb2bf"))

    title = tab.title
    if len(title) > 30:
        title = title[:29] + '…'
    num = str(tab.index + 1)

    if tab.is_active:
        yield ("\ue0b6", accent, bg)
        yield (f" {num}: {title} ", white, accent)
        yield ("\ue0b4", accent, bg)
    else:
        yield (f" {num}: {title} ", inactive_fg, bg)
    yield (" ", inactive_fg, bg)
