{ pkgs, hyprland, ... }:

{
  # Use the Hyprland package from the flake input so versions always match
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;

    settings = {

      # ── Monitors ────────────────────────────────────────────────────────
      # "preferred" auto-detects resolution/refresh. Add more entries for
      # multi-monitor setups: "monitor = DP-1, 2560x1440@144, 1920x0, 1"
      monitor = ", preferred, auto, 1";

      # ── Autostart ───────────────────────────────────────────────────────
      exec-once = [
        "swww-daemon"                          # Wallpaper daemon
        "dunst"                                # Notifications
        "waybar"                               # Status bar
        "swayidle -w timeout 300 'swaylock -f' timeout 600 'systemctl suspend' before-sleep 'swaylock -f'"
        "wl-paste --watch cliphist store"      # Clipboard history
      ];

      # ── Environment variables (passed to Wayland session) ───────────────
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      # ── Input ───────────────────────────────────────────────────────────
      input = {
        kb_layout = "us";       # Change to your keyboard layout
        follow_mouse = 1;
        sensitivity = 0;        # -1.0 to 1.0; 0 = no adjustment
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
          drag_lock = true;
        };
      };

      # ── General appearance ───────────────────────────────────────────────
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border"   = "rgba(cba6f7ff) rgba(89b4faff) 45deg"; # Catppuccin mauve→blue
        "col.inactive_border" = "rgba(45475aff)";
        layout = "dwindle";
        resize_on_border = true;
      };

      # ── Decoration (rounding, blur, shadows) ────────────────────────────
      decoration = {
        rounding = 10;
        active_opacity   = 1.0;
        inactive_opacity = 0.92;

        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          new_optimizations = true;
        };

        shadow = {
          enabled = true;
          range = 12;
          render_power = 3;
          color = "rgba(1a1a2ebb)";
        };
      };

      # ── Animations ──────────────────────────────────────────────────────
      animations = {
        enabled = true;
        bezier = [
          "easeOut,  0.16, 1, 0.3, 1"
          "easeIn,   0.7, 0, 0.84, 0"
          "linear,   0, 0, 1, 1"
        ];
        animation = [
          "windows,     1, 4,  easeOut, slide"
          "windowsOut,  1, 3,  easeIn,  slide"
          "border,      1, 10, linear"
          "fade,        1, 5,  easeOut"
          "workspaces,  1, 4,  easeOut, slidevert"
        ];
      };

      # ── Layout ──────────────────────────────────────────────────────────
      dwindle = {
        pseudotile = true;      # Super + P to toggle
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      # ── Miscellaneous ───────────────────────────────────────────────────
      misc = {
        force_default_wallpaper = 0;  # Disable Hyprland anime wallpaper
        disable_hyprland_logo   = true;
        vfr = true;                   # Variable frame rate — saves power
      };

      # ── Window rules ────────────────────────────────────────────────────
      windowrulev2 = [
        # Float common utility windows
        "float, class:^(pavucontrol)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(file-roller)$"
        "float, title:^(Picture in picture)$"

        # Scratchpad terminal (see keybind below)
        "float,       class:^(scratchpad)$"
        "size 800 500,class:^(scratchpad)$"
        "center,      class:^(scratchpad)$"

        # Fix XWayland apps
        "xwayland:1, class:^(.*)"
      ];

      # ── Keybinds ────────────────────────────────────────────────────────
      # SUPER = Windows/Meta key
      "$mod" = "SUPER";

      bind = [
        # Apps
        "$mod, Return,      exec, alacritty"
        "$mod, E,           exec, alacritty --class scratchpad"  # Scratchpad term
        "$mod, B,           exec, firefox"
        "$mod, Space,       exec, rofi -show drun"               # App launcher
        "$mod SHIFT, S,     exec, grimblast copy area"           # Screenshot region
        "$mod, V,           exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

        # Window management
        "$mod, Q,           killactive"
        "$mod SHIFT, Q,     exit"
        "$mod, F,           fullscreen, 0"
        "$mod SHIFT, F,     togglefloating"
        "$mod, P,           pseudo"                              # Dwindle pseudotile
        "$mod, J,           togglesplit"

        # Focus (vim-style)
        "$mod, H,           movefocus, l"
        "$mod, L,           movefocus, r"
        "$mod, K,           movefocus, u"
        "$mod, J,           movefocus, d"

        # Move windows
        "$mod SHIFT, H,     movewindow, l"
        "$mod SHIFT, L,     movewindow, r"
        "$mod SHIFT, K,     movewindow, u"
        "$mod SHIFT, J,     movewindow, d"

        # Workspaces 1–9
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        # Move window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        # Scratchpad workspace
        "$mod, S,           togglespecialworkspace, magic"
        "$mod SHIFT, S,     movetoworkspace, special:magic"

        # Scroll through workspaces with mouse wheel on bar
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up,   workspace, e-1"

        # Lock screen
        "$mod, Escape,      exec, swaylock"
      ];

      # Mouse drag to move/resize
      bindm = [
        "$mod, mouse:272, movewindow"    # LMB drag = move
        "$mod, mouse:273, resizewindow"  # RMB drag = resize
      ];

      # Media & brightness (work without SUPER)
      bindel = [
        ", XF86AudioRaiseVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp,   exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindl = [
        ", XF86AudioMute,        exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay,        exec, playerctl play-pause"
        ", XF86AudioNext,        exec, playerctl next"
        ", XF86AudioPrev,        exec, playerctl previous"
      ];
    };
  };

  # ── Waybar ──────────────────────────────────────────────────────────────
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 32;
      spacing = 4;

      modules-left   = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right  = [
        "pulseaudio" "network" "cpu" "memory"
        "battery" "tray" "custom/power"
      ];

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          "1" = ""; "2" = ""; "3" = "󰝚";
          "4" = ""; "5" = "";
          active = "";
          default = "";
        };
        on-click = "activate";
        sort-by-number = true;
      };

      clock = {
        format = " {:%a %d %b  %H:%M}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      cpu = {
        format = " {usage}%";
        tooltip = false;
      };

      memory = { format = " {}%"; };

      battery = {
        states = { warning = 30; critical = 15; };
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-icons = [ "" "" "" "" "" ];
      };

      network = {
        format-wifi = "  {signalStrength}%";
        format-ethernet = "󰈀";
        format-disconnected = "󰤭 Offline";
        tooltip-format = "{ifname}: {ipaddr}";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟";
        format-icons = { default = [ "" "" "" ]; };
        on-click = "pavucontrol";
      };

      tray = { spacing = 8; };

      "custom/power" = {
        format = "⏻";
        on-click = "swaylock";
        tooltip = false;
      };
    }];

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(30, 30, 46, 0.85);
        color: #cdd6f4;
      }

      #workspaces button {
        padding: 0 8px;
        color: #6c7086;
        background: transparent;
      }
      #workspaces button.active {
        color: #cba6f7;
        border-bottom: 2px solid #cba6f7;
      }
      #workspaces button:hover {
        color: #cdd6f4;
        background: rgba(203, 166, 247, 0.1);
      }

      #clock, #cpu, #memory, #battery,
      #network, #pulseaudio, #tray, #custom-power {
        padding: 0 10px;
        color: #cdd6f4;
      }

      #battery.warning  { color: #f9e2af; }
      #battery.critical { color: #f38ba8; }
      #clock { color: #89b4fa; }
    '';
  };

  # ── Dunst (notifications) ────────────────────────────────────────────────
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = 320;
        height = 120;
        offset = "12x48";
        origin = "top-right";
        transparency = 10;
        frame_color = "#cba6f7";
        frame_width = 2;
        corner_radius = 10;
        font = "JetBrainsMono Nerd Font 11";
        format = "<b>%s</b>\n%b";
        icon_theme = "Papirus-Dark";
        enable_recursive_icon_lookup = true;
      };
      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 4;
      };
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 6;
      };
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#f38ba8";
        frame_color = "#f38ba8";
        timeout = 0;
      };
    };
  };

  # ── Swaylock ────────────────────────────────────────────────────────────
  programs.swaylock = {
    enable = true;
    settings = {
      color             = "1e1e2e";
      bs-hl-color       = "f38ba8";
      caps-lock-bs-hl-color = "f38ba8";
      caps-lock-key-hl-color = "f9e2af";
      inside-color      = "00000000";
      inside-clear-color = "00000000";
      inside-ver-color  = "00000000";
      inside-wrong-color = "00000000";
      key-hl-color      = "a6e3a1";
      line-color        = "00000000";
      ring-color        = "cba6f7";
      ring-clear-color  = "f2cdcd";
      ring-ver-color    = "89b4fa";
      ring-wrong-color  = "f38ba8";
      text-color        = "cdd6f4";
      text-clear-color  = "f2cdcd";
      text-ver-color    = "89b4fa";
      text-wrong-color  = "f38ba8";
      indicator-radius  = 80;
      indicator-thickness = 8;
      clock             = true;
      timestr           = "%H:%M";
      datestr           = "%a, %d %B";
    };
  };
}
