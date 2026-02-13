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

}
