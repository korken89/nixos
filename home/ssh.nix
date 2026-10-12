{
  pkgs,
  lib,
  ...
}:
let
  # Use the LAN address when it answers, otherwise fall back to the VPN.
  lanFirst =
    {
      name,
      lan,
      vpn,
      user,
    }:
    {
      "${name}-lan" = lib.hm.dag.entryBefore [ name ] {
        header = ''Match originalhost ${name} exec "${pkgs.netcat}/bin/nc -z -w 1 ${lan} 22 2>/dev/null"'';
        HostName = lan;
      };
      ${name} = {
        HostName = vpn;
        User = user;
        # Same host key on both addresses
        HostKeyAlias = name;
      };
    };
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings =
      lanFirst {
        name = "emifre-home-workstation";
        lan = "192.168.1.176";
        vpn = "emifre-home-workstation.kiteshield.wg";
        user = "emifre";
      }
      // {
        emifre-work-workstation = {
          HostName = "emifre-workstation.kiteshield.wg";
          User = "emifre";
        };
      };
  };
}
