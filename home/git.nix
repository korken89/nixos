{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Git
  programs.difftastic = {
    enable = true;
    options.color = "always";
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
