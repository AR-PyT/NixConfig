{ lib, pkgs, unstable,  ... }:
let
  plymouth_theme = pkgs.stdenv.mkDerivation {
        pname = "PlymouthTheme";
        version = "1.1";
        src = pkgs.fetchFromGitHub {
          owner = "yi78";
          repo = "hellonavi";
          rev = "master";
          hash = "sha256-0A79TB2fEDJ3O8pU/+aIFYuFtuGUBj5eYYjWK5IwF4A";
        };
        buildInputs = [ pkgs.plymouth ];
        installPhase = ''
          mkdir -p $out/share/plymouth/themes/hellonavi
          cp -r hellonavi/* $out/share/plymouth/themes/hellonavi
        '';
      };
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

      theme = lib.mkForce (pkgs.stdenv.mkDerivation {
        pname = "GrubTheme";
        version = "1.2";
        src = pkgs.fetchFromGitHub {
          owner = "13atm01";
          repo = "GRUB-Theme";
          rev = "master";
          hash = "sha256-4aW8IEkIFC3IZ/GdC2xLrFyDvbnBEvFyFHB4gsZxmWE=";
        };
        installPhase = "cp -r \"Doki Doki Literature Club (Chibi Version)/Chibi-DDLC-Version\" $out";
      });
    };
    timeout = 3;
    efi.canTouchEfiVariables = true;
  };

  boot.consoleLogLevel = 3;  # Show logs with level >= 3 (default 4)
  boot.initrd.systemd.enable = true;  # Enable systemd (needed for plymouth with nvidia)
  boot.plymouth = {
    enable = true;
    font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    themePackages = lib.mkForce [ plymouth_theme ];
    theme = lib.mkForce "hellonavi";
  };
}
