{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    heroic
    prismlauncher
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
