#!/usr/bin/env python3
# Custom kitty tab bar with powerline rounded capsule tabs
# Based on https://github.com/kovidgoyal/kitty/discussions/4447#discussioncomment-12324426

from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, draw_title, as_rgb
from kitty.utils import color_as_int


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    orig_fg = screen.cursor.fg
    orig_bg = screen.cursor.bg
    left_sep, right_sep = ('\ue0b6', '\ue0b4')

    def draw_sep(which: str) -> None:
        screen.cursor.bg = as_rgb(color_as_int(draw_data.default_bg))
        screen.cursor.fg = orig_bg
        screen.draw(which)
        screen.cursor.bg = orig_bg
        screen.cursor.fg = orig_fg

    if max_tab_length <= 1:
        screen.draw('…')
    elif max_tab_length == 2:
        screen.draw('…|')
    elif max_tab_length < 6:
        draw_sep(left_sep)
        screen.draw((' ' if max_tab_length == 5 else '') + '…' + (' ' if max_tab_length >= 4 else ''))
        draw_sep(right_sep)
    else:
        draw_sep(left_sep)
        screen.draw(' ')
        draw_title(draw_data, screen, tab, index)
        extra = screen.cursor.x - before - max_tab_length
        if extra >= 0:
            screen.cursor.x -= extra + 3
            screen.draw('…')
        elif extra == -1:
            screen.cursor.x -= 2
            screen.draw('…')
        screen.draw(' ')
        draw_sep(right_sep)
        draw_sep(' ')

    return screen.cursor.x
