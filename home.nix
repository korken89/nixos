{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ inputs.stylix.homeManagerModules.stylix ];

  stylix = {
    enable = true;
    polarity = "dark";
    image = pkgs.fetchurl {
      url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
      sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/default-dark.yaml";
    fonts = {
      monospace = {
        name = "Fira Code";
        package = pkgs.fira-code;
      };
      # serif = {
      #   name = userSettings.font;
      #   package = userSettings.fontPkg;
      # };
      # sansSerif = {
      #   name = userSettings.font;
      #   package = userSettings.fontPkg;
      # };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-emoji;
      };
      sizes = {
        terminal = 12;
        applications = 10;
        popups = 10;
        desktop = 10;
      };
    };
    targets.alacritty.enable = true;
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "emifre";
  home.homeDirectory = "/home/emifre";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable ssh agent (https://wiki.nixos.org/wiki/SSH_public_key_authentication)
  services.ssh-agent.enable = true;

  # Git
  programs.git = {
    enable = true;
    userName = "Emil Fresk";
    userEmail = "emil.fresk@gmail.com";

    difftastic = {
      enable = true;
      color = "always";
    };

    aliases = {
      ci = "commit";
      co = "checkout";
      st = "status";
    };
  };
}
