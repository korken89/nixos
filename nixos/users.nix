{ pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.emifre = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Emil Fresk";
    extraGroups = [
      "audio"
      "docker"
      "networkmanager"
      "plugdev"
      "wheel"
      "wireshark"
    ];

    openssh.authorizedKeys.keys = [
      # curl https://gitlab.com/korken89.keys
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0GikMdLCc/fblrNkPZ6El2CcSQUKwILODZ7J2CAP27 Emil Fresk (gitlab.com)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0H4FwVWDsnGrIXU2J590raVWhbGc5vx5qwVzrH5Vs8 Emil Fresk (gitlab.com)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH5zmlJY9VDbDlFYxU3Q6jjT9yyBB3/FJajqMiPYvw6B Emil Fresk (gitlab.com)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1xvogP5S5I3Er6+O5ctuYQJxtJD90Kjy2S3x1wxB0L Emil Fresk (gitlab.com)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM33C+JR1Wqo8StKL0VA4gQE7TT37F2IIFgGko5e+WhR Emil Fresk (gitlab.com)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMoXn2bjd1dQjSTE8ZdnwEUqvDDbJNUmcRMIIzkgwASa Emil Fresk (gitlab.com)"
    ];
  };
}
