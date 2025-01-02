{ pkgs, user, ... }:
let
  inherit (import ../variables.nix) gitUsername;
in
{
  users.users.${user} = {
    isNormalUser = true;
    description = "${gitUsername}";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "lp" "scanner" "audio" "video" ];
    packages = with pkgs; [];
    initialPassword = "password";
  };
}