{ pkgs, ... }:
let
  uname = (import ../variables.nix).user;
  name = (import ../variables.nix).gitUsername;
in
{
  users.users.${uname} = {
    isNormalUser = true;
    description = "${name}";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "lp" "scanner" "audio" "video" ];
    packages = with pkgs; [];
    initialPassword = "password";
  };
}