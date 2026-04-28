{ ... }:

{
  programs.git = {
    enable = true;

    # ── Change these ────────────────────────────────────────────────────
    userName  = "Alex Polson";
    userEmail = "alex@alexpolson.com";
    # ───────────────────────────────────────────────────────────────────

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";

      diff.colorMoved = "default";
      merge.conflictstyle = "diff3";

      # Helpful aliases
      alias = {
        st  = "status -sb";
        co  = "checkout";
        br  = "branch";
        lg  = "log --oneline --graph --decorate --all";
        undo = "reset HEAD~1 --mixed";
      };
    };

    ignores = [
      ".DS_Store"
      "*.swp"
      ".direnv"
      ".envrc"
      "result"
      "result-*"
    ];
  };
}
