{ lib, pkgs, unstable,  ... }:
let
  plymouth_theme = pkgs.stdenv.mkDerivation {
      pname = "PlymouthTheme";
      version = "1.1";
      src = pkgs.fetchFromGitHub {
        owner = "AR-PyT";
        repo = "NixConfig";
        rev = "plymouth-custom-theme";
        hash = "sha256-8BAYxpclo/pa4L+/VpxDupmhWvdwXnbh8NUT2nSnea8=";
      };
      buildInputs = [ pkgs.plymouth ];
      installPhase = ''
        mkdir -p $out/share/plymouth/themes/hellonavi
        cp -r hellonavi/* $out/share/plymouth/themes/hellonavi
        cat hellonavi/hellonavi.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/hellonavi/hellonavi.plymouth
      '';
    };

    dynamic_grub_theme = pkgs.stdenv.mkDerivation {
      pname = "GrubTheme";
      version = "1.0";
      src = pkgs.fetchFromGitHub {
        owner = "AR-PyT";
        repo = "NixConfig";
        rev = "grub";
        hash = "sha256-GY5VLEynpl1R/kZyX6Db5zN8Rd7rZ/OirkSB3scfS0w=";
      };

      installPhase = ''
        mkdir -p $out
        cp -r ./* $out
        
        max_dir=-1

        # Will assume that at least one directory exists
        for dir in {0..59}; do
          if [ -d "$out/$dir" ]; then
            max_dir=$dir
          fi
        done

        # Create links for directories that do not exist
        for i in $(seq $(( max_dir+1 )) 59); do
          # Calculate target directory in the cycle (20, 19, ..., 0, 20, ...)
          target_idx=$(( (max_dir - (i % (max_dir + 1))) % (max_dir + 1) ))
          if [ $target_idx -lt 0 ]; then
            target_idx=$(( target_idx + max_dir + 1 ))
          fi

          # Create symbolic link
          cp -r $out/$target_idx $out/$i
        done
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

      theme = lib.mkForce dynamic_grub_theme;
      extraConfig = ''
        insmod datehook
        load_env
        set grub_background=($drive1)//theme/$SECOND/theme.txt
        set theme=$grub_background
        save_env grub_background
      '';
    };
    timeout = 3;
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = false;
  };

  boot.consoleLogLevel = 3;  # Show logs with level >= 3 (default 4)
  boot.initrd.systemd.enable = true;  # Enable systemd (needed for plymouth with nvidia)
  boot.initrd.availableKernelModules = [ "i915" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.plymouth = {
    enable = true;
    font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    themePackages = lib.mkForce [ plymouth_theme pkgs.plymouth-vortex-ubuntu-theme ];
    theme = lib.mkForce "hellonavi";
  };
}
