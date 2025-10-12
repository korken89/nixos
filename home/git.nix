{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Git
  programs.git = {
    enable = true;
    userName = "Emil Fresk";
    # userEmail = "emil.fresk@gmail.com";

    extraConfig = {
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

    difftastic = {
      enable = true;
      options.color = "always";
    };

    aliases = {
      ci = "commit";
      co = "checkout";
      st = "status";
      l = "log --all --graph --oneline";
      rl = "!git log --all --graph --oneline --decorate=on --color | tac";
    };
  };

}
