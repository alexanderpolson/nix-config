{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-a";           # Remap prefix from C-b to C-a
    escapeTime = 0;
    historyLimit = 10000;
    mouse = true;
    baseIndex = 1;            # Windows start at 1 instead of 0
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      catppuccin
      sensible
      yank                    # System clipboard integration
      {
        plugin = resurrect;   # Save/restore sessions
        extraConfig = "set -g @resurrect-capture-pane-contents 'on'";
      }
      {
        plugin = continuum;   # Auto-save sessions every 15 min
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
    ];

    extraConfig = ''
      # True colour support
      set -ag terminal-overrides ",xterm-256color:RGB"

      # Vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Split with | and -  (keeps current path)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      # Status bar
      set -g status-position top
    '';
  };
}
