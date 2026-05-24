{ pkgs, config, ... }: {
  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
    BROWSER = "zen-beta";
  };

  programs.dconf.enable = true;

  services = {
    libinput.enable = true;
    dbus = {
      enable = true;
      implementation = "broker";
      packages = with pkgs; [ gcr gnome-settings-daemon ];
    };
    gvfs.enable = true;
    upower.enable = true;
    udisks2.enable = true;
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 78;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };

  environment.pathsToLink = [ "/share/zsh" ];

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
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
    ];
  };

  security = {
    pam.services.hyprlock.text = "auth include login";
    sudo.wheelNeedsPassword = true;
  };
}