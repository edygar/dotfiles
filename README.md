     _     _           _
    | |   | |         | |
    | |___| |_____  __| | ____     Yet Another Dotfile Repo
    |_____  (____ |/ _  |/ ___)
     _____| / ___ ( (_| | |        @edygar's Version
    (_______\_____|\____|_|

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[![Build Status](https://travis-ci.org/edygar/dotfiles.svg?branch=master)](https://travis-ci.org/edygar/dotfiles)&nbsp;![PRs Welcome][prs-badge]&nbsp;![OS X supported][apple-logo]

---

This repository was highly inspirated by [Luiz Filho's dotfiles](https://github.com/lfilho/dotfiles).

## Installation

### One liner for OS X

To get started please run:

```bash
sh -c "`curl -fsSL https://raw.githubusercontent.com/edygar/dotfiles/master/install.sh`"
```

## Setup

### NVIM

Browse the `plugins/*.vim` files to see which plugins we have.

Files in `nvim/settings` are our configurations or customizations.

- `nvim/settings/plugin-*.vim` are configs for a specific plugin.
- `nvim/settings/*.vim` are general vim configs.
- Whatever you **don't** see in the above files (or if a plugin doesn't have a correspondent file in there) means that we use that plugin's (or vim's) defaults.

If you are having an unexpected behavior, wondering why a particular key works the way it does, use: `:map [keycombo]` (e.g. `:map <C-\>`) to see what the key is mapped to. For bonus points, you can see where the mapping was set by using `:verbose map [keycombo]`. If you omit the key combo, you'll get a list of all the maps. You can do the same thing with `nmap`, `imap`, `vmap`, etc.

## How to customize

You can place any number of `*.vim` files inside the folders `before` and `after` in the `settings` dir. They'll be loaded, accordingly, before or after the main installation and configuration steps.
If you think something could benefit everybody, feel free to open a Pull Request.

## key bindings

The leader key is the default's <kbd>\\</kbd>, but <kbd>space</kbd> is mapped to it, so it's easier to reach with both hands.

### Navigation

Prompts uses [denite](https://github.com/Shougo/denite.nvim).

- <kbd>space</kbd><kbd>f</kbd><kbd>f</kbd> `[f]ind [f]ile` - Prompts for file path with fuzzy matching.
- <kbd>space</kbd><kbd>f</kbd><kbd>b</kbd> `[f]ind [b]uffers` - Prompts for the buffer with fuzzy matching.
- <kbd>space</kbd><kbd>f</kbd><kbd>g</kbd> `[f]ind by [g]reping` - Prompts on the command-line for grepping the project.

The following mapping applies when the prompt is open:

- <kbd>ctrl</kbd><kbd>p</kbd> `[p]revious` - Highlights the previous file. (alias: <kbd>ctrl</kbd><kbd>k</kbd>)
- <kbd>ctrl</kbd><kbd>n</kbd> `[n]next` - Highlights the next file. (<kbd>ctrl</kbd><kbd>j</kbd>)
- <kbd>ctrl</kbd><kbd>s</kbd> `[s]plit view` - Opens the highlighted file on a split view.
- <kbd>ctrl</kbd><kbd>v</kbd> `[v]ertical split view` - Opens the highlighted file on a vertical split view.
- <kbd>ctrl</kbd><kbd>t</kbd> `open in a new [t]tab` - Opens the highlighted file on a new tab.
- <kbd>ctrl</kbd><kbd>o</kbd> `[o]pen` - Opens the file.

### Tabs

- <kbd>t</kbd><kbd>h</kbd> `[h]jkl` - Switches to the first tab.
- <kbd>t</kbd><kbd>l</kbd> `hjk[l]` - Switches to the last tab.
- <kbd>t</kbd><kbd>p</kbd> `switch to [p]revious tab` - Switches to the next tab. (aliases: <kbd>t</kbd><kbd>j</kbd>, <kbd>t</kbd><kbd>[</kbd>)
- <kbd>t</kbd><kbd>n</kbd> `switch to [n]ext tab` - Switches to the next tab. (aliases: <kbd>t</kbd><kbd>k</kbd>, <kbd>t</kbd><kbd>]</kbd>)
- <kbd>t</kbd><kbd>m</kbd> `[m]ove tab` - Moves the tab to given position.
- <kbd>t</kbd><kbd>c</kbd> `[c]lose tab` - Closes the current tab. (alias: <kbd>t</kbd><kbd>d</kbd>)
- <kbd>t</kbd><kbd>1</kbd> <kbd>t</kbd><kbd>2</kbd> <kbd>t</kbd><kbd>3</kbd> … `tab to [#]th position` - Switches to tab on given position.

### GIT

- <kbd>space</kbd><kbd>g</kbd><kbd>g</kbd> `[g]o to lazy[g]it` - Opens lazygit into its own tab.
- <kbd>space</kbd><kbd>g</kbd><kbd>b</kbd> `[g]it [b]lame` - Shows blame annotations
- <kbd>space</kbd><kbd>g</kbd><kbd>d</kbd> `[g]it [d]iff` - Shows git diff

### Terminal

- <kbd>space</kbd><kbd>t</kbd><kbd>t</kbd> `[t]oggle [t]erminal` - Opens :term into its own tab.
- <kbd>esc</kbd><kbd>esc</kbd> - Goes to Terminal Mode (similar to normal mode but for the terminal buffer)

[apple-logo]: https://img.shields.io/badge/macos-supported-blue.svg?logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABEAAAAUCAYAAABroNZJAAAABGdBTUEAALGPC%2FxhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAACXBIWXMAAAsTAAALEwEAmpwYAAACAmlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS40LjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczpleGlmPSJodHRwOi8vbnMuYWRvYmUuY29tL2V4aWYvMS4wLyIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iPgogICAgICAgICA8ZXhpZjpQaXhlbFlEaW1lbnNpb24%2BNjY8L2V4aWY6UGl4ZWxZRGltZW5zaW9uPgogICAgICAgICA8ZXhpZjpQaXhlbFhEaW1lbnNpb24%2BNTU8L2V4aWY6UGl4ZWxYRGltZW5zaW9uPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4Ktkd%2F7gAAAiNJREFUOBGNUz1rG0EQ1UnRSZiDRMYmjbqAITJJpUaV22DiXxDSmYB%2FgcH%2FJFWKNCFpTH6CW0FUBKH0EVKEkC46fZ10H%2Bv35naPUyJbWpibnTezb2dn5nK5PZZSqgDJ7xG6PYQE2z17oobA87yTxWJxOxwO3%2FKowR%2BkYYCWIoMGg8GLIAi8MAwVSOrEHiSBIw%2BxGJRdURR9Aa6gPxhcx6Y1ekIHQcuyYu6n0%2BnLUqlk%2B77fbTabDm5%2FE8fxD8dxOsDOkdFvxP7cOEcCAu12216v158RhEujJeTPfD4f9Pv9eDKZLPkcYAo6ANm3Xq93ZIiYhTwBBJ8YlBX40qXxAFkp1EiNx%2BNXmiTp3mw2e61vihHMVKhlZXCcj2GGCsW%2B0gRSDvnYtn2GdxIPIdIVaAE0zn2MfQFPcVut1i1sLqmj1APOpwm2%2B4v0lp1OZ8lInFPUpk1rGjuWhQLl0LnDRqNxzFjYUg8hAbu0DPhjI06SsFgslmu12rW%2BMAImz865rvsMBeuCjN3h2uhS1jbFXa1WNyYbTmmhUqn8hfOrYdd6q2I2LDZ0VQeIIU8ajUZVZOOCjFn4kAAik6f3tH36ETdEm5%2BTBGRJXbGRVmMy33OQEJwKDqR74rTR5gtNIOeSoiSMyNJSGLx35XL5EsRTvPsOk%2FwLc3SKrtThPwDJR%2Fi%2Fw1%2BAHZFsY8GRkm44%2FjEQZ0ZDPP8dMjdowmzLza38481eSO4BM4sOer2f%2BQ4AAAAASUVORK5CYII%3D
[prs-badge]: https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAACWFBMVEXXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWkrXWko2FeWCAAAAAXRSTlMAQObYZgAAAAFiS0dEAIgFHUgAAAAJcEhZcwAAI28AACNvATX8B%2FsAAAAHdElNRQfhBQMBMCLAfV85AAAAi0lEQVQ4y2NgIBYszkPmJc5ORZE9DgEJqNxmmPS%2B43AA4h5B5TIwbD5%2BHFnoKCoXYSBMBIW7CF0eAxChoPM4ARXHB4GCZEIKKA8H%2FCoWE1LAwIBfBVp6wQA1DPhVzMJMcyggCVuqxGI%2FLhWY6Z6QPKoK7HmHkDwDwxYC8gwMdSDprXiz6PHjpQxUBgCLDfI7GXNh5gAAAABJRU5ErkJggg%3D%3D
