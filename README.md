# Dotfiles

My personal macOS dotfiles, managed as a bare git repository with files stored at their actual locations (no symlinks).

## Overview

| Component | Tool | Config Location |
|---|---|---|
| Terminal | Kitty | `~/.config/kitty/` |
| Shell | Zsh + Starship | `~/.config/zsh/` |
| Editor | AstroNvim (Neovim) | `~/.config/nvim/` |
| Window Manager | AeroSpace | `~/.config/aerospace/` |
| Status Bar | SketchyBar | `~/.config/sketchybar/` |
| Window Borders | JankyBorders | `~/.config/borders/` |
| Launcher | Leader Key | `~/.config/leader-key/` |
| Mouse Control | Mouseless | GUI (v1.0.0) |
| Keyboard Nav | Homerow | `~/.config/homerow/` |
| Git | delta, lazygit | `~/.config/git/`, `~/.config/lazygit/` |
| Search | ripgrep, fzf, zoxide | `~/.config/ripgrep/` |
| Version Manager | mise | `~/.config/mise/` |
| Password Manager | 1Password | — |
| Passwords (CLI) | gcloud SDK | `~/google-cloud-sdk/` |

## Setup

### One-Shot Install (Fresh Machine)

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/edygar/dotfiles/main/.local/bin/bootstrap.sh)"
```

This will:
1. Clone the bare repo to `~/Code/personal/dotfiles`
2. Check out all config files to their actual locations
3. Run the full install script (Homebrew, defaults, fonts, etc.)
4. Prompt for API keys and work email

### Manual Setup

If you prefer to do it step by step:

```bash
# Clone the bare repo
git clone --bare git@github.com:edygar/dotfiles.git ~/Code/personal/dotfiles

# Set up the alias
alias dotfiles="git --git-dir=$HOME/Code/personal/dotfiles --work-tree=$HOME"

# Checkout files
dotfiles checkout

# Run the install script
~/.local/bin/install_dotfiles.sh
```

The install script handles:
1. Homebrew + all packages from Brewfile
2. macOS system defaults (menu bar autohide, dock, finder, keyboard, trackpad)
3. Unsplash API key prompt (for wallpaper rotation)
4. Git work identity (`.gitconfig.work`)
5. Leader Key config symlink
6. Homerow config import
7. Default app association for code files (Neovim.app)
8. Cron jobs (hourly wallpaper rotation)
9. Initial wallpaper download

### Manual Steps After Install

- Restart kitty (fully quit, not just reload)
- Run `:Lazy sync` in nvim
- Grant accessibility permissions: System Settings > Privacy & Security
  - Mouseless, Homerow, AeroSpace
- Configure Mouseless via GUI (`mouseless://settings`)
- Add Raycast script commands from `~/.local/bin/raycast-*.zsh`
- Rebuild neovim: `~/.local/bin/buildnvim.sh` (if using local build)
- Install SF Pro font: `brew install --cask font-sf-pro` (requires sudo)

## Shell

### Zsh (`~/.config/zsh/`)

- **`.zshrc`**: Main config — mise, starship, zsh-autosuggestions, .nvmrc auto-switching, gcloud SDK
- **`aliases.zsh`**: Git aliases, navigation, ls/eza with icons, zoxide, functions
- **`key-bindings.zsh`**: Vi mode (`bindkey -v`), kitty window close, autosuggestions
- **`.zshenv`**: XDG paths, mise shims first in PATH

### Key Features

- Vi mode in shell (`KEYTIMEOUT=1`)
- `.nvmrc` auto-switching via mise
- Google Cloud SDK in PATH
- SauceCodePro Nerd Font throughout

## Terminal

### Kitty (`~/.config/kitty/`)

- **Font**: SauceCodePro Nerd Font
- **Colors**: Gruvbox dark theme
- **Scrollback**: Neovim pager (`nvim_open_term`) with `q`/`Ctrl-C`/`Shift+Q` to quit
- **Window nav**: `Ctrl+h/j/k/l` via vim-kitty-navigator (IS_VIM user var)
- **Remote control**: `allow_remote_control yes`, `listen_on unix:/tmp/mykitty`
- **Icon**: Alternate `>^_^<` cat icon from sodapopcan/kitty-icon
- **Tab bar**: Custom active/inactive colors (`#659DDA` active)
- **Transparent background**: 0.8 opacity, 30 blur

### Key Bindings

| Key | Action |
|---|---|
| `Cmd+e` | Open scrollback in nvim |
| `Cmd+Shift+.` | Open nvim config tab |
| `Ctrl+h/j/k/l` | Navigate between nvim splits / kitty windows |

## Editor

### Neovim / AstroNvim (`~/.config/nvim/`)

- **Plugin Manager**: lazy.nvim
- **Theme**: onedarker (with transparent background)
- **Picker**: Snacks.nvim (files, grep, buffers, explorer, LSP)
- **Status bar**: Heirline (tabline with tab numbers)
- **LSP**: vtsls, lua_ls, efm (formatting/linting via mason)
- **Completion**: blink.cmp
- **Syntax**: Treesitter with textobjects
- **Git**: gitsigns, diffview, gitlinker
- **Navigation**: dropbar (breadcrumbs), hop (jump), syntax-tree-surfer
- **Diagnostics**: tiny-inline-diagnostic, trouble
- **File explorer**: Snacks explorer (replaces nvim-tree)
- **Search**: grug-far (find & replace)
- **Testing**: neotest (jest)
- **DAP**: nvim-dap (jest debugging)
- **Other**: which-key, noice, undotree, oil, auto-save, nvim-surround, mini.indentscope

### Custom Keymaps

| Key | Action |
|---|---|
| `<Leader>ff` | Find files (Snacks) |
| `<Leader>fg` | Live grep (Snacks) |
| `<Leader>e` | Toggle explorer (Snacks) |
| `<Leader>ul` | Toggle line number style (both/relative) |
| `<Leader>uv` | Toggle inline diagnostics |
| `<Leader>gb` | Git blame line |
| `<Leader>gd` | Open diffview |
| `<Leader>ss` | Find & replace (grug-far) |
| `<Leader><Leader>` | Hop jump |
| `<Leader>gw` | Git worktree picker |

### Per-Project Config

`.localrc.lua` files in project roots provide project-specific keymaps and LSP settings. See `after/plugin/localrc.lua` for the loader.

## Window Management

### AeroSpace (`~/.config/aerospace/`)

- **Workspaces**: A S D F Z X V Q R T (keyboard layout order)
- **Layout**: Accordion (default), tiles, floating
- **Gaps**: 8px inner, 46px top (for sketchybar), 8px others
- **Start at login**: Yes
- **Config version**: 2
- **JankyBorders**: Launched on startup, `#659DDA` active, `style=round`

### Key Bindings

| Key | Action |
|---|---|
| `Alt+letter` | Switch to workspace |
| `Alt+Shift+letter` | Move window to workspace |
| `Alt+h/j/k/l` | Focus left/down/up/right |
| `Alt+Shift+h/j/k/l` | Move window |
| `Alt+Cmd+Enter` | Toggle tiles layout |
| `Alt+Shift+Enter` | Toggle accordion layout |
| `Alt+Esc` | Service mode (reload, reset, fullscreen, floating) |
| `Alt+-` / `Alt+=` | Resize |

### SketchyBar (`~/.config/sketchybar/`)

- **Left**: AeroSpace workspaces (A-Z) with app icons, focused workspace accented
- **Left**: Current focused app name with icon
- **Right**: Calendar, Volume, Battery, CPU usage
- **Font**: SF Pro (icons), SauceCodePro Nerd Font (space letters)
- **Colors**: Dark blue bar, accent on focused space only
- **Auto-update**: On workspace change and focus change via aerospace callbacks

### JankyBorders (`~/.config/borders/`)

- `style=round`, `width=3.0`
- Active: `#659DDA` (matches kitty active tab)
- Inactive: `#494d64`

## Launcher

### Leader Key (`~/.config/leader-key/`)

Config symlinked from `~/.config/leader-key/config.json` to `~/Library/Application Support/Leader Key/config.json`.

| Key | Group |
|---|---|
| `g` | Go to (Browser, Slack, WhatsApp, Kitty, Notes, Gmail, Calendar, etc.) |
| `s` | Search (Browser tabs, Files, Slack, WhatsApp) |
| `f` | Browse folder (Home, Downloads, Desktop) |
| `F` | Open folder (Home, Desktop, Downloads) |
| `r` | Raycast (Screenshots, Notes, Ticket, Snippets) |
| `w` | Workspace (AeroSpace: A, B, D, F, G, M, O, P, Q, R, S, T, U, V, X, Z) |
| `a` | AeroSpace (Reset, Floating, Fullscreen, Close, Join) |
| `c` | Change case |
| `Shift+R` | Reload (Kitty, AeroSpace, Leader Key, Mouseless, SketchyBar) |

All URLs use `raycast-x://` scheme (except script commands which use `raycast://`).

## Scripts (`~/.local/bin/`)

### Raycast Scripts

| Script | Description |
|---|---|
| `raycast-next-wallpaper.zsh` | Switch to next wallpaper |
| `raycast-previous-wallpaper.zsh` | Switch to previous wallpaper |
| `raycast-reload-configs.zsh` | Reload all configs (kitty, aerospace, leader key, mouseless, sketchybar) |
| `raycast-git-quick-commit.zsh` | Stage tracked files, prompt commit message, push |
| `raycast-dotfiles-commit.zsh` | Show dotfiles diff, select files, nvim commit, push |

### Kitty Scripts

| Script | Description |
|---|---|
| `dotfiles.zsh` | Open dotfiles in nvim (kitty tab) |
| `nvim-config.zsh` | Open nvim config in kitty tab |
| `lazygit.zsh` | Open lazygit in kitty tab |
| `kitty-launcher.zsh` | Launch commands in kitty split panes |
| `tab_title.zsh` | Generate kitty tab titles with git branch |

### Browser Scripts

| Script | Description |
|---|---|
| `focus-tab.js` | Focus a Chrome tab (AppleScript) |
| `focus-url-tab` | Focus or open a tab by URL |
| `list-tabs.js` | List all Chrome tabs (for Raycast) |

### System Scripts

| Script | Description |
|---|---|
| `macos-defaults.zsh` | Set macOS system preferences |
| `install_dotfiles.sh` | Full machine setup script |
| `buildnvim.sh` | Build neovim from source |
| `open-in-nvim.zsh` | Open files in nearest running nvim (via kitty remote control) |
| `wallpaper.zsh` | Fetch space/astronomy wallpapers (JWST + NASA APOD + Unsplash) |
| `organize_windows.sh` | Organize windows with AeroSpace |
| `toggle-chain-click.zsh` | Toggle Homerow chain clicks |
| `dismiss-notifications.applescript` | Dismiss macOS notifications |
| `get-ticket.sh` | Get Jira ticket from clipboard |
| `shortcut.sh` | Launch app and trigger shortcut |
| `json.sh` | Parse clipboard as JSON |
| `sh.sh` | Run shell commands via Raycast |

## Neovim.app (Finder Integration)

An app bundle at `~/Applications/Neovim.app` (not tracked in git) that:
- Shows up in Finder's "Open with" menu with the Neovim icon
- Opens files in the nearest running nvim instance via kitty remote control
- Is set as default for 50+ code file extensions via `duti`

## Wallpaper System

Wallpapers are fetched from three sources (in priority order):
1. **NASA APOD** — Astronomy Picture of the Day (free, high quality processed images)
2. **JWST API** — James Webb Space Telescope raw images (free key at jwstapi.com)
3. **Unsplash** — Space/astronomy themed backup

- Stored in `~/.config/wallpapers/` (gitignored)
- API keys in `~/.config/wallpapers/.unsplash-key` and `.jwst-key` (gitignored)
- Rotates hourly via cron job
- Next/Previous via Raycast scripts
- Minimum resolution filter (1000x500)

## Git Configuration

- **Main config**: `~/.config/git/config` (aliases, delta pager, nvim as editor)
- **Personal identity**: `~/.gitconfig.user` (edygar@users.noreply.github.com)
- **Work identity**: `~/.gitconfig.work` (gitignored, prompted on install)
- **Conditional includes**: `~/Code/work/` uses work identity
- **Lazygit**: Custom commands (`s` sync, `S` force sync, `K` commit --no-verify, `o` edit config)

## Fonts

| Font | Usage |
|---|---|
| SauceCodePro Nerd Font | Kitty, Neovim, eza icons, starship |
| SF Pro | SketchyBar icons |
| sketchybar-app-font | SketchyBar app icons |

## macOS Defaults

Set via `macos-defaults.zsh`:
- Dock: autohide, no delay
- Menu bar: always hide
- Finder: show hidden files, list view, path bar, status bar
- Keyboard: fast key repeat, no auto-correct
- Trackpad: tap to click
- Screenshots: no shadow, save to Desktop
- Windows: minimize on double-click title bar

## License

Personal dotfiles. Use at your own risk.
