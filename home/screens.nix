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
            name = "work_workstation";
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
                scale = 1.0;
              }
              {
                criteria = "Dell Inc. DELL U2518D 3C4YP7BK268L";
                mode = "2560x1440@59.951";
                position = "3840,-200";
                transform = "270";
                scale = 1.0;
              }
            ];
          };
        }

        # Thinkpad E14 laptop
        {
          profile = {
            name = "thinkpad_e14";
            outputs = [
              {
                criteria = "AU Optronics 0x403D Unknown";
                scale = 1.0;
              }
            ];
          };
        }

        # Yoga 7x laptop
        {
          profile = {
            name = "yoga_7x";
            outputs = [
              {
                criteria = "Samsung Display Corp. 0x4189 Unknown";
                scale = 1.5;
              }
            ];
          };
        }

        # 42" LG OLED TV screen
        {
          profile = {
            name = "home_workstation";
            outputs = [
              {
                criteria = "LG Electronics LG TV SSCR2 0x01010101";
                mode = "3840x2160@119.880";
                position = "0,0";
                # alias = "home_lg_tv";
              }
            ];
          };
        }

        # # yoga 7x laptop docking
        # {
        #   profile = {
        #     name = "undocked";
        #     outputs = [
        #       {
        #         criteria = "edp-1";
        #         status = "enable";
        #       }
        #     ];
        #   };
        # }
        # {
        #   profile = {
        #     name = "home_large_docked";
        #     outputs = [
        #       {
        #         criteria = "$yoga_laptop";
        #         status = "disable";
        #       }
        #       {
        #         criteria = "$home_lg_tv";
        #         status = "enable";
        #       }
        #     ];
        #   };
        # }
      ];
    };
  };
}
