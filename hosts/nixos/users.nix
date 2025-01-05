{ pkgs, username, ... }:
let
  inherit (import ./variables.nix) gitUsername;
in
{
  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "audio"
      ];
      initialPassword = "password";
      packages = with pkgs; [
      ];
    };
  };
}
