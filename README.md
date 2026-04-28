# NixOS Configuration

A barebones but complete NixOS + Home Manager configuration using Nix Flakes.

## Directory Structure

```
nixos-config/
├── flake.nix                        # Entry point — inputs and outputs
├── hosts/
│   └── nixos/
│       ├── configuration.nix        # System-level config (boot, users, Hyprland, Wayland)
│       └── hardware-configuration.nix  # YOU provide this (see Step 1)
└── home/
    ├── default.nix                  # Home Manager root — packages & session vars
    └── programs/
        ├── hyprland.nix             # Hyprland compositor, Waybar, Dunst, Swaylock
        ├── zsh.nix                  # Zsh + Starship prompt
        ├── git.nix                  # Git identity and aliases
        ├── neovim.nix               # Neovim with LSP, Telescope, Catppuccin
        ├── tmux.nix                 # Tmux with session persistence
        └── alacritty.nix            # Alacritty terminal + JetBrainsMono Nerd Font
```

---

## Step 1 — Personalise the Config

Before doing anything else, do a find-and-replace across the repo:

| Placeholder        | Replace with                          |
|--------------------|---------------------------------------|
| `youruser`         | Your Linux username                   |
| `Your Name`        | Your full name (used in git.nix)      |
| `you@example.com`  | Your email (used in git.nix)          |
| `nixos`            | Your desired hostname                 |
| `America/New_York` | Your timezone (`timedatectl list-timezones`) |

---

## Step 2 — Place your hardware config

If you bootstrapped with `nixos-install`, you already have a generated hardware
config at `/etc/nixos/hardware-configuration.nix`. Copy it into place:

```bash
cp /etc/nixos/hardware-configuration.nix hosts/nixos/hardware-configuration.nix
```

If you haven't generated one yet:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/nixos/hardware-configuration.nix
```

---

## Step 3 — Move your config into place & enable Flakes

Put this repo somewhere permanent (e.g. `~/.config/nixos` or `~/nixos-config`).
Flakes must be enabled for the first rebuild. If they aren't yet:

```bash
# Add to /etc/nixos/configuration.nix temporarily, then rebuild normally once:
nix.settings.experimental-features = [ "nix-command" "flakes" ];
sudo nixos-rebuild switch
```

---

## Step 4 — First Flake Build

From inside the repo directory:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

Replace `nixos` with your hostname if you changed it. This will:
- Build and activate the NixOS system config
- Build and activate your Home Manager config as a NixOS module

---

## Day-to-Day Commands

```bash
# Apply changes after editing any .nix file
sudo nixos-rebuild switch --flake .#nixos

# Update all flake inputs (nixpkgs, home-manager) to latest
nix flake update

# Or update a single input
nix flake update nixpkgs

# Garbage collect old generations (automatic weekly, but can run manually)
sudo nix-collect-garbage -d

# Roll back the last switch if something broke
sudo nixos-rebuild switch --rollback

# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

The `zsh.nix` config also defines these as short aliases:

| Alias     | Expands to                                   |
|-----------|----------------------------------------------|
| `rebuild` | `sudo nixos-rebuild switch --flake .#`       |
| `update`  | `nix flake update`                           |
| `cleanup` | `sudo nix-collect-garbage -d`                |

---

## Adding More Packages

**System-wide** (available to all users) → `hosts/nixos/configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  wget curl git vim
  your-new-package   # add here
];
```

**Per-user** (via Home Manager) → `home/default.nix`:
```nix
home.packages = with pkgs; [
  ripgrep fzf fd
  your-new-package   # add here
];
```

**As a new program module** → create `home/programs/yourprog.nix` and add it to the
`imports` list in `home/default.nix`.

---

## Included Software

### Compositor & Desktop
- **Hyprland** — Wayland compositor (from the upstream flake for latest features)
- **Waybar** — status bar with workspaces, clock, CPU/RAM, battery, volume, network
- **Dunst** — notification daemon
- **Swaylock** — lock screen (clock overlay, Catppuccin colours)
- **Swayidle** — auto-lock after 5 min idle, suspend after 10 min
- **rofi-wayland** — app launcher (`Super + Space`)
- **swww** — wallpaper daemon
- **grimblast** — screenshot tool (region: `Super + Shift + S`)
- **cliphist** — clipboard history (`Super + V` → rofi picker)

### CLI Tools
- `ripgrep`, `fzf`, `fd`, `bat`, `eza`, `htop`, `jq`, `tree`
- `wl-clipboard`, `brightnessctl`, `playerctl`, `pavucontrol`

### Dev
- `git` (configured with aliases and sane defaults)
- `neovim` (LSP-ready, Telescope, Catppuccin Mocha, which-key)
- `tmux` (session persistence via resurrect + continuum, vim-style panes)
- `gcc`, `gnumake`

### Shell
- `zsh` with autosuggestions, syntax highlighting, and fzf bindings
- `starship` prompt with git and Nix shell indicators

### GUI
- `alacritty` terminal (Catppuccin Mocha, JetBrainsMono Nerd Font)
- `firefox` (Wayland native via `MOZ_ENABLE_WAYLAND`)
- `vlc`

---

## Hyprland Keybinds

| Keybind | Action |
|---|---|
| `Super + Return` | Open Alacritty |
| `Super + Space` | App launcher (rofi) |
| `Super + B` | Firefox |
| `Super + Q` | Close window |
| `Super + F` | Fullscreen |
| `Super + Shift + F` | Toggle float |
| `Super + H/J/K/L` | Move focus (vim-style) |
| `Super + Shift + H/J/K/L` | Move window |
| `Super + 1–9` | Switch workspace |
| `Super + Shift + 1–9` | Move window to workspace |
| `Super + S` | Toggle scratchpad workspace |
| `Super + Shift + S` | Screenshot region → clipboard |
| `Super + V` | Clipboard history picker |
| `Super + Escape` | Lock screen |
| `Super + Shift + Q` | Exit Hyprland |
| `Super + LMB drag` | Move window |
| `Super + RMB drag` | Resize window |
