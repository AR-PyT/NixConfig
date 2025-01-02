{ lib, pkgs, unstable,  ... }:
let
  theme_v1 = import ./plymouth_theme.nix { inherit lib pkgs; };
in
{
  # Bootloader
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 5;  # Limit NIXOS configs

      theme = libmkForce pkgs.stdenv.mkDerivation {
        pname = "distro-grub-themes";
        version = "3.1";
        src = pkgs.fetchFromGitHub {
          owner = "AdisonCavani";
          repo = "distro-grub-themes";
          rev = "v3.1";
          hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
        };
        installPhase = "cp -r customize/nixos $out";
      };

    };
    timeout = 3;
    efi.canTouchEfiVariables = true;
  };

  boot.consoleLogLevel = 3;  # Show logs with level >= 3 (default 4)
  boot.initrd.systemd.enable = true;  # Enable systemd (needed for plymouth with nvidia)
  boot.plymouth = {
    enable = true;
    font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    themePackages = lib.mkForce [ theme_v1 ];
    theme = lib.mkForce "theme_v1";
  };
}
