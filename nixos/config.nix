{ config, pkgs, options, lib, inputs, pkgs-unstable, ... }:
let
  inherit (import ../variables.nix) host username;
in
{
  imports = [
    ./hardware.nix
    ./users.nix
    ../modules/nvidia-drivers.nix
    ../modules/nvidia-prime-drivers.nix
    ../modules/intel-drivers.nix
    ../modules/local-hardware-clock.nix
    ../modules/keyboard.nix
    ../modules/boot
  ];

  # stylix.targets.gnome.enable = false;
  # stylix.targets = {
  #   gnome.enable = false;
    
  #   # Keep these enabled for basic theming
  #   gtk.enable = true;
  #   qt.enable = true;
  # };

  # Styling Options
  stylix = {
    enable = true;
    image = ../config/wallpapers/wp4.png;
    base16Scheme = {
      base00 = "1d2021"; # ----
      base01 = "383c3e"; # ---
      base02 = "53585b"; # --
      base03 = "6f7579"; # -
      base04 = "cdcdcd"; # +
      base05 = "d5d5d5"; # ++
      base06 = "dddddd"; # +++
      base07 = "e5e5e5"; # ++++
      base08 = "d72638"; # red
      base09 = "eb8413"; # orange
      base0A = "f19d1a"; # yellow
      base0B = "88b92d"; # green
      base0C = "1ba595"; # aqua/cyan
      base0D = "1e8bac"; # blue
      base0E = "be4264"; # purple
      base0F = "c85e0d"; # brown
    };
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
            # package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
            package = pkgs.nerd-fonts.jetbrains-mono;  # Updated to new format
            name = "JetBrainsMono Nerd Font Mono";
          };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  # Extra Module Options
  drivers.intel.enable = true;
  drivers.nvidia.enable = true;
  drivers.nvidia-prime = {
    enable = true;
  };
  local.hardware-clock.enable = true;

  # Enable networking
  # networking.wireless.iwd = {
  #   enable = true;
  #   settings.General.EnableNetworkConfiguration = true;
  # };
  networking.networkmanager.enable = true;
  networking.hostName = host;
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LANGUAGE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_COLLATE = "en_US.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
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

  programs = {
    firefox.enable = true;
    fish.enable = true;
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        buf = {
          symbol = " ";
        };
        c = {
          symbol = " ";
        };
        directory = {
          read_only = " 󰌾";
        };
        docker_context = {
          symbol = " ";
        };
        fossil_branch = {
          symbol = " ";
        };
        git_branch = {
          symbol = " ";
        };
        golang = {
          symbol = " ";
        };
        hg_branch = {
          symbol = " ";
        };
        hostname = {
          ssh_symbol = " ";
        };
        lua = {
          symbol = " ";
        };
        memory_usage = {
          symbol = "󰍛 ";
        };
        meson = {
          symbol = "󰔷 ";
        };
        nim = {
          symbol = "󰆥 ";
        };
        nix_shell = {
          symbol = " ";
        };
        nodejs = {
          symbol = " ";
        };
        ocaml = {
          symbol = " ";
        };
        package = {
          symbol = "󰏗 ";
        };
        python = {
          symbol = " ";
        };
        rust = {
          symbol = " ";
        };
        swift = {
          symbol = " ";
        };
        zig = {
          symbol = " ";
        };
      };
    };
    dconf.enable = true;
    seahorse.enable = false;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;
  };

  # Essential sandboxing
  security.chromiumSuidSandbox.enable = true;

  # Virtualization
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers = {
    members = [ username ];
  };

  # Docker
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ username ];
  virtualisation.docker.rootless = {
  enable = true;
  setSocketVariable = true;
  };


  environment.systemPackages = with pkgs; [
    # (import ../modules/zen-browser {inherit pkgs-unstable; })
    # (import ../modules/zen-browser.nix {inherit pkgs-unstable; })
    pcmanfm

    # System Utitlities
    firefox
    gsimplecal
    overskride
    xfce.thunar
    greetd.tuigreet
    hyprcursor
    hyprcursor
    wl-clipboard
    wlr-randr
    xwayland
    hyprpicker
    hyprlock
    hypridle
    brightnessctl
    usbutils
    lshw
    pciutils
    smartmontools
    xdg-utils
    killall
    lm_sensors
    libnotify
    lxqt.lxqt-policykit
    swww
    pkg-config

    # Development Tools
    python312
    gcc
    clang
    cmake
    git
    vim
    neovim
    nix-tree
    vscode
    ninja

    # Terminal Utilities
    kitty
    fish
    btop
    htop
    ranger
    wget
    unzip
    unrar
    zip
    ripgrep
    tree
    cmatrix
    eza
    lolcat
    bat
    tree
    grim

    # Applications
    # mullvad-vpn
    ferdium
    swappy
    chromium
    remmina
    file-roller
    wpsoffice
    swaynotificationcenter
    neovide
    slurp
    playerctl

    # Audio and Videa
    pavucontrol
    mpv
    v4l-utils
    ffmpeg
    imv

    # VPN
    protonvpn-gui
    protonvpn-cli

    # Misc
    discord
    zoom-us
    libvncserver
    turbovnc
    tailscale
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk-sans
      nerd-fonts.jetbrains-mono
      font-awesome
      symbola
      material-icons
    ];
  };

  environment.variables = {
    BUILD_VERSION = "1.2";
    HYYPR_NIXOS = "true";
  };

  # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
    config.common.default = "hyprland";
  };

  # systemd.targets.sleep.enable = false;
  # systemd.targets.suspend.enable = false;
  # systemd.targets.hibernate.enable = false;
  # systemd.targets.hybrid-sleep.enable = false;
  # Services to start
  services = {
    power-profiles-daemon.enable = false;
    # gnome.desktop = {
    #   enable = true; # Disable GNOME Desktop Environment
    # };
    # desktopManager.gnome.enable = true;
    displayManager.defaultSession = "hyprland";
    # x2goserver.enable = true;
    xserver = {
      enable = false;
      # displayManager.sddm.enable = true;
      # desktopManager.plasma5.enable = true;
    };
    # xrdp = {
    #   enable = true;
    #   defaultWindowManager = "startplasma-x11";
    #   openFirewall = true;
    # };
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          # Wayland Desktop Manager is installed only for user ryan via home-manager!
          user = username;
          # .wayland-session is a script generated by home-manager, which links to the current wayland compositor(sway/hyprland or others).
          # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config here.
          # command = "$HOME/.wayland-session"; # start a wayland session directly without a login manager
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland"; # start Hyprland with a TUI login manager
        };
      };
    };
    smartd = {
      enable = false;
      autodetect = true;
    };
    libinput.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    # openssh = {
    #   enable = true;
    #   # ports = [ 6523 ];
    #   settings = {
    #     PasswordAuthentication = false;
    #     PermitRootLogin = "no";
    #     AllowUsers = [ "abdul" ];
    #   };
    # };
    flatpak.enable = false;
    printing = {
      enable = true;
      drivers = [
        # pkgs.hplipWithPlugin
      ];
    };
    gnome.gnome-keyring.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
    syncthing = {
      enable = false;
      user = "${username}";
      dataDir = "/home/${username}";
      configDir = "/home/${username}/.config/syncthing";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    rpcbind.enable = false;
    nfs.server.enable = false;
    geoclue2.enable = true;
    tailscale.enable = true;
    tlp = {
     enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 78;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };
  # systemd.services.flatpak-repo = {
  #   path = [ pkgs.flatpak ];
  #   script = ''
  #     flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  #   '';
  # };
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };

  # Extra Logitech Support
  hardware.logitech.wireless.enable = false;
  hardware.logitech.wireless.enableGraphical = false;

  # Bluetooth Support
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Support sound
  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;
  
  # Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
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
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # Power Button Setting
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = false;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.firewall = {
    # enable the firewall
    enable = true;
    checkReversePath = "loose"; # Important for reliable connectivity
    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "proton0" "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];

    # allow you to SSH in over the public internet
    allowedTCPPorts = [ 22 ];
  };

  # services.mullvad-vpn.package = pkgs.mullvad-vpn;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
