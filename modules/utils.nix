{ pkgs
, config
, ...
}:
{
  environment.variables = {
    XDG_DATA_HOME = "$HOME/.local/share";
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    EDITOR = "nvim";
    TERMINAL = "kitty";
    TERM = "kitty";
    BROWSER = "zen-beta";
  };

  services.libinput.enable = true;
  programs.dconf.enable = true;
  services = {
    dbus = {
      enable = true;
      implementation = "broker";
      packages = with pkgs; [ gcr gnome-settings-daemon ];
    };
    gvfs.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = false;
    udisks2.enable = true;
    ipp-usb.enable = true;
    geoclue2.enable = true;
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 78;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
    psd = {
      enable = false;
      resyncTimer = "10m";
    };
  };

  # enable zsh autocompletion for system packages (systemd, etc)
  environment.pathsToLink = [ "/share/zsh" ];

  # Faster rebuilding
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "gtk" "hyprland" ];
    };

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security = {
    # allow wayland lockers to unlock the screen
    pam.services.hyprlock.text = "auth include login";
    # userland niceness
    rtkit.enable = true;
    # ask for password for wheel group
    sudo.wheelNeedsPassword = true;
  };
}
