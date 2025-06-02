{
  pkgs,
  ...
}:

{
  services = {
    swayidle = {
      enable = true;
      package = pkgs.swayidle;
      timeouts = [
        {
          timeout = 300;
          command = "${pkgs.swaylock-effects}/bin/swaylock -f -F -c 000000 --grace 5 --grace-no-mouse";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock-effects}/bin/swaylock -f -F -c 000000";
        }
      ];
    };
  };
}
