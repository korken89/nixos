{
  config,
  pkgs,
  username,
  ...
}:

let
  user = config.users.users.${username};
  mountPoint = "/kiteshield_sync";
in
{
  systemd.tmpfiles.rules = [
    "d ${mountPoint} 0755 ${username} users -"
  ];

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "kiteshield-mount" ''
      ${pkgs.sshfs}/bin/sshfs \
        -o reconnect \
        -o ServerAliveInterval=15 \
        -o ServerAliveCountMax=3 \
        -o ConnectTimeout=10 \
        -o IdentityFile=${user.home}/.ssh/id_ed25519 \
        filebrowser-quantum@files.kiteshield.com:/var/files/kiteshield \
        ${mountPoint}
    '')
    (pkgs.writeShellScriptBin "kiteshield-umount" ''
      fusermount -u ${mountPoint}
    '')
  ];
}
