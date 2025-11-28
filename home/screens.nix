{
  config,
  pkgs,
  lib,
  ...
}:

{
  services = {
    kanshi = {
      enable = true;
      settings = [
        # Work screens
        {
          profile = {
            name = "work";
            outputs = [
              # {
              #   criteria = "Samsung Electric Company C34J79x H4ZRA01366";
              #   mode = "3440x1440@59.973";
              #   position = "0,0";
              # }
              {
                criteria = "Lenovo Group Limited L32p-30 U5128TW7";
                mode = "3840x2160@59.997";
                position = "0,0";
                scale = 1.25;
              }
              {
                criteria = "Dell Inc. DELL U2518D 3C4YP7BK268L";
                mode = "2560x1440@59.951";
                position = "3840,-200";
                transform = "270";
              }
            ];
          };
        }

        # Yoga 7x laptop
        {
          output = {
            criteria = "eDP-1";
            scale = 1.5;
            alias = "yoga_laptop";
          };
        }

        # 42" LG OLED TV screen
        {
          output = {
            criteria = "LG Electronics LG TV SSCR2 0x01010101";
            mode = "3840x2160@119.880";
            position = "0,0";
            alias = "home_lg_tv";
          };
        }

        # Yoga 7x laptop docking
        {
          profile = {
            name = "undocked";
            outputs = [
              {
                criteria = "eDP-1";
                status = "enable";
              }
            ];
          };
        }
        {
          profile = {
            name = "home_large_docked";
            outputs = [
              {
                criteria = "$yoga_laptop";
                status = "disable";
              }
              {
                criteria = "$home_lg_tv";
                status = "enable";
              }
            ];
          };
        }
      ];
    };
  };
}
