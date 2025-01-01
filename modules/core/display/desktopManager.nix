{ pkgs, ... }:

{
  services.displayManager.defaultSession = "hyprland";
  programs.hyprland.enable = true;
  # programs.hyprland.packages = pkgs.hyprland.packages.${pkgs.system}.hyprland;

  environment = 
    let
      exec = "exec dbus-launch Hyprland";
    in
    {
      loginShellInit = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          ${exec}
        fi
      '';

      variables = {
        # WLR_NO_HARDWARE_CURSORS="1"; # Needed for VM
        # WLR_RENDERER_ALLOW_SOFTWARE="1";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "Hyprland";
        XCURSOR = "Catppuccin-Mocha-Dark-Cursors";
        XCURSOR_SIZE = 24;
        NIXOS_OZONE_WL = 1;
        SDL_VIDEODRIVER = "wayland";
        OZONE_PLATFORM = "wayland";
        WLR_RENDERER_ALLOW_SOFTWARE = 1;
        CLUTTER_BACKEND = "wayland";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_QPA_PLATFORMTHEME = "qt6ct";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = 1;
        GDK_BACKEND = "wayland";
        WLR_NO_HARDWARE_CURSORS = "1";
        MOZ_ENABLE_WAYLAND = "1";
      };
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
      };

      systemPackages = with pkgs; [
        grimblast # Screenshot
        hyprcursor # Cursor
        hyprpaper # Wallpaper
        wl-clipboard # Clipboard
        wlr-randr # Monitor Settings
        xwayland # X session
        hyprpicker
        hyprlock
        hypridle
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
}
