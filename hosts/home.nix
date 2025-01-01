{ pkgs, ... }:
let
  inherit (import ./variables.nix) gitUsername gitEmail user;
in
{
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "24.11";

  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };
}