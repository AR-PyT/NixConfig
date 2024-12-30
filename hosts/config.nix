{ 
  config, 
  pkgs,
  pkgs-unstable,
  host,
  user,
  options,
  ... 
}:
let
  inherit (import ./variables.nix) keyboardLayout;
in
{
  imports =
    [
      ./hardware.nix
      ./users.nix
      ../modules
    ];

  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_latest;
    # This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # Graphics KMS
    # WARNING: NVIDIA drivers not up to date in latest kernels
    # initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

    # Bootloader
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 5;  # Limit NIXOS configs
      };
      timeout = 5;
      efi.canTouchEfiVariables = true;
    };
    # Make /tmp a tmpfs
    tmp = {
      cleanOnBoot = true;
      tmpfsSize = "5GB";
    };
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = host;
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
      kitty # Terminal Emulator
      fish # Terminal Emulator
      btop # Resource Manager
      cifs-utils # Samba
      coreutils # GNU Utilities
      git # Version Control
      killall # Process Killer
      lshw # Hardware Config
      vim # Text Editor
      nvim # Text Editor
      nix-tree # Browse Nix Store
      pciutils # Manage PCI
      ranger # File Manager
      smartmontools # Disk Health
      tldr # Helper
      usbutils # Manage USB
      wget # Retriever
      xdg-utils # Environment integration
      vscode # Code Editor

      # Video/Audio
      alsa-utils # Audio Control
      feh # Image Viewer
      mpv # Media Player
      pavucontrol # Audio Control
      pipewire # Audio Server/Control
      pulseaudio # Audio Server/Control
      qpwgraph # Pipewire Graph Manager
      vlc # Media Player

      # Apps
      appimage-run # Runs AppImages on NixOS
      firefox # Browser
      remmina # XRDP & VNC Client

      # File Management
      file-roller # Archive Manager
      pcmanfm # File Browser
      p7zip # Zip Encryption
      rsync # Syncer - $ rsync -r dir1/ dir2/
      unzip # Zip Files
      unrar # Rar Files
      wpsoffice # Office
      zip # Zip
      
      # Linux commands
      ripgrep # Search
      tree # Directory
    ] ++
    (with pkgs-unstable; [
      cursor # VSode Alternative
    ]);

  # Setting up display
  services = {
    displayManager = {
      defaultSession = "hyprland";
      sddm.enable = true;
      sddm.wayland.enable = true;
    };

    xserver.desktopManager.gnome.enable = true;
    xserver.enable = true;
    # Configure keymap
    xserver.xkb = {
     layout = "us";
     variant = "";
    };
    xserver.windowManager.i3.enable = true;
  
    # NVIDIA drivers
    xserver.videoDrivers = [ "nvidia" ];
  };


  # Security / Polkit
  security = {
    rtkit.enable = true;
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
    };

    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };


  # Pipewire setup (Sound)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth support
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    hsphfpd.enable = false;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # Touchpad
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "Abdul Rehman";
    extraGroups = [ "networkmanager" "wheel" "lp" "scanner" "audio" "video" ];
    packages = with pkgs; [];
    initialPassword = "password";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  programs.hyprland.enable = true;

  # Fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      nerdfonts
      font-awesome
      material-icons
    ];
  };

  # Portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    config.common.default = "hyprland";
  };
  
  # Nix Optimized Settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  home-manager.users.${user} = {
    home = {
      stateVersion = "24.11";
    };
    programs = {
      home-manager.enable = true;
    };
    xdg = {
      mime.enable = true;
      mimeApps = lib.mkIf (config.gnome.enable == false) {
        enable = true;
        defaultApplications = {
          "image/jpeg" = [ "image-roll.desktop" "feh.desktop" ];
          "image/png" = [ "image-roll.desktop" "feh.desktop" ];
          "text/plain" = "nvim.desktop";
          "text/html" = "nvim.desktop";
          "text/csv" = "nvim.desktop";
          "application/pdf" = [ "wps-office-pdf.desktop" "firefox.desktop" ];
          "application/zip" = "org.gnome.FileRoller.desktop";
          "application/x-tar" = "org.gnome.FileRoller.desktop";
          "application/x-bzip2" = "org.gnome.FileRoller.desktop";
          "application/x-gzip" = "org.gnome.FileRoller.desktop";
          "x-scheme-handler/http" = [ "firefox.desktop" ];
          "x-scheme-handler/https" = [ "firefox.desktop" ];
          "x-scheme-handler/about" = [ "firefox.desktop" ];
          "x-scheme-handler/unknown" = [ "firefox.desktop" ];
          "x-scheme-handler/mailto" = [ "gmail.desktop" ];
          "audio/mp3" = "mpv.desktop";
          "audio/x-matroska" = "mpv.desktop";
          "video/webm" = "mpv.desktop";
          "video/mp4" = "mpv.desktop";
          "video/x-matroska" = "mpv.desktop";
          "inode/directory" = "pcmanfm.desktop";
        };
      };
    };
  };
}
