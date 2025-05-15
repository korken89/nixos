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
        {
          profile = {
            name = "work";
            outputs = [
              {
                criteria = "Samsung Electric Company C34J79x H4ZRA01366";
                mode = "3440x1440@59.973";
                position = "0,0";
              }
              {
                criteria = "Dell Inc. DELL U2518D 3C4YP7BK268L";
                mode = "2560x1440@59.951";
                position = "3440,-680";
                transform = "270";
              }
            ];
          };
        }
        # TODO: {
        #   profile = {
        #     name = "home";
        #     outputs = [
        #       {
        #         criteria = "...";
        #         mode = "2560x1440";
        #         position = "0,0";
        #       }
        #     ];
        #   };
        # }
      ];
    };
  };
}
