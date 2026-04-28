{ pkgs, hyprland, ... }:

{
  imports = [
    ./programs/zsh.nix
    ./programs/git.nix
    ./programs/neovim.nix
    ./programs/tmux.nix
    ./programs/alacritty.nix
    ./programs/hyprland.nix
  ];

  # ── User-level packages ──────────────────────────────────────────────────
  home.packages = with pkgs; [
    # CLI tools
    ripgrep
    fzf
    fd
    bat
    eza
    htop
    jq
    tree
    unzip
    zip

    # Dev
    gcc
    gnumake

    # GUI apps
    firefox
    vlc
    warp-terminal   # Unfree — requires nixpkgs.config.allowUnfree = true (set in flake.nix)

    # AI / dev tools
    claude-code     # Installed via sadjow/claude-code-nix flake overlay

    # Wayland / Hyprland ecosystem
    waybar           # Status bar
    dunst            # Notification daemon
    rofi-wayland     # App launcher
    swww             # Wallpaper daemon
    swaylock         # Lock screen
    swayidle         # Idle management (dim/lock/sleep)
    grimblast        # Screenshot tool (wraps grim + slurp)
    wl-clipboard     # CLI clipboard
    cliphist         # Clipboard history
    brightnessctl    # Backlight control
    pavucontrol      # PulseAudio / PipeWire volume GUI
    playerctl        # MPRIS media key control
  ];

  # ── Session variables ────────────────────────────────────────────────────
  home.sessionVariables = {
    EDITOR   = "nvim";
    BROWSER  = "firefox";
    # Wayland
    NIXOS_OZONE_WL     = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM    = "wayland";
  };

  # Required — set to your username and home directory
  home.username = "apolson";
  home.homeDirectory = "/home/apolson";

  # Required — do not change
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
