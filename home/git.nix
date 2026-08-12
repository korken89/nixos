{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Git, pager, ui
  programs.lazygit = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
    options = {
      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-decoration-style = "none";
        file-style = "bold yellow ul";
      };
      features = "decorations line-numbers";
      whitespace-error-style = "22 reverse";
    };
  };

  programs.git = {
    enable = true;
    # userEmail = "emil.fresk@gmail.com";
    signing.format = null;

    settings = {
      user.name = "Emil Fresk";
      alias = {
        ci = "commit";
        co = "checkout";
        st = "status";
        l = "log --all --graph --oneline";
        rl = "!git log --all --graph --oneline --decorate=on --color | tac";
      };
      pull.rebase = true;
      fetch = {
        prune = true;
        all = true;
      };

      diff = {
        colorMoved = true;
        colorMovedWS = "allow-indentation-change";
      };
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      ui = {
        default-command = [
          "log"
          "--reversed"
          "-r"
          "::"
          "--limit"
          "20"
        ];
        # Real git as diff formatter: jj's builtin ":git" has no move
        # detection, so delta never sees --color-moved colors.
        # mkForce: delta's enableJujutsuIntegration also sets this.
        diff-formatter = lib.mkForce "git-diff";
      };

      merge-tools.git-diff = {
        program = "git";
        diff-args = [
          "--no-pager"
          "diff"
          "--no-index"
          "--color=always"
          "--color-moved=default"
          "--color-moved-ws=allow-indentation-change"
          "$left"
          "$right"
        ];
        diff-expected-exit-codes = [
          0
          1
        ];
      };

      user.name = "Emil Fresk";
    };
  };
}
