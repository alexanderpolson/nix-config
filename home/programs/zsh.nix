{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      share = true;
    };

    shellAliases = {
      ls  = "eza --icons";
      ll  = "eza -la --icons";
      lt  = "eza --tree --icons";
      cat = "bat";
      vim = "nvim";

      # Nix shortcuts
      rebuild = "sudo nixos-rebuild switch --flake .#";
      update  = "nix flake update";
      cleanup = "sudo nix-collect-garbage -d";
    };

    initContent = ''
      # fzf key bindings (Ctrl+R for history, Ctrl+T for files)
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh

      # Better dir navigation
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
    '';

    plugins = [
      {
        name = "zsh-autopair";
        src = pkgs.zsh-autopair;
        file = "share/zsh/zsh-autopair/autopair.zsh";
      }
    ];
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol   = "[❯](bold red)";
      };
      directory.truncate_to_repo = false;
      git_branch.symbol = " ";
      nix_shell = {
        symbol = " ";
        impure_msg = "[impure](bold red)";
        pure_msg   = "[pure](bold green)";
      };
    };
  };
}
