{ pkgs, user, ... }:
let
  inherit (import ../variables.nix) gitUsername;
in
{
  programs.fish.enable = true;
  users.users.${user} = {
    isNormalUser = true;
    description = "${gitUsername}";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "lp" "scanner" "audio" "video" ];
    packages = with pkgs; [];
    initialPassword = "password";
  };
}