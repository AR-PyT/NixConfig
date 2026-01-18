# Hyprland is a dynamic tiling Wayland compositor that is highly customizable and performant.
{ pkgs
, config
, lib
, ...
}:
let
  border-size = 2;
  gaps-in = 4;
  gaps-out = 10;
  active-opacity = 1.0;
  inactive-opacity = 0.8;
  rounding = 10;
  blur = true;
  keyboardLayout = "us";
  background = "rgba(" + config.lib.stylix.colors.base00 + "77)";
in
{
  imports = [
    ./animations.nix
    ./bindings.nix
    ./polkitagent.nix
  ];

  home.packages = with pkgs; [
    swww
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    hyprland-qtutils
    adw-gtk3
    hyprshot
    hyprpicker
    swappy
    imv
    wf-recorder
    wlr-randr
    brightnessctl
    gnome-themes-extra
    libva
    dconf
    wayland-utils
    wayland-protocols
    glib
    direnv
    meson
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd = {
      enable = false;
      variables = [
        "--all"
      ]; # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
    };
    package = null;
    portalPackage = null;

    settings = {
      exec-once = [
        "dbus-update-activation-environment --systemd --all &"
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "killall -q swww;sleep .5 && swww init"
        "sleep 1.5 && wallsetter"

        "[workspace special:utils silent] blueman-manager"
        "[workspace special:info silent] kitty btop"
      ];

      monitor = [
        ",prefered,auto,1" # default
      ];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "MOZ_ENABLE_WAYLAND,1"
        "ANKI_WAYLAND,1"
        "DISABLE_QT5_COMPAT,0"
        "NIXOS_OZONE_WL,1"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM=wayland,xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "__GL_GSYNC_ALLOWED,0"
        "__GL_VRR_ALLOWED,0"
        "DISABLE_QT5_COMPAT,0"
        "DIRENV_LOG_FORMAT,"
        "WLR_DRM_NO_ATOMIC,1"
        "WLR_BACKEND,vulkan"
        "WLR_RENDERER,vulkan"
        "WLR_NO_HARDWARE_CURSORS,1"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
      ];

      general = {
        resize_on_border = true;
        gaps_in = gaps-in;
        gaps_out = gaps-out;
        border_size = border-size;
        layout = "dwindle";
        "col.inactive_border" = lib.mkForce background;
      };

      decoration = {
        active_opacity = active-opacity;
        inactive_opacity = inactive-opacity;
        rounding = rounding;
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
        };
        blur = {
          enabled =
            if blur
            then "true"
            else "false";
          size = 5;
          passes = 3;
          new_optimizations = "on";
          ignore_opacity = "off";
        };
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        smart_split = true;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_forever = true;
      };

      windowrule = [
        "match:class protonvpn-app, float on"
        "match:class protonvpn-app, center on"
        "match:class protonvpn-app, size 500 400"

        "float, swayimg|vlc|Viewnior|pavucontrol|zoom|mpv|nm-connection-editor|blueman-manager"
        "opacity 1.0 0.8, class:^(kitty)$"
        "opacity 0.95 0.8, class:^(firefox)$"
        "opacity 0.9 0.7, class:^(thunar)$"
      ];

      misc = {
        disable_hyprland_logo = true;
        background_color = "0x24273a";
        initial_workspace_tracking = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
      };

      input = {
        kb_layout = "us";
        kb_options = "terminate:ctrl_alt_bksp";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 0.8;
        };
        sensitivity = 1; # -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat";
        scroll_method = "2fg";
      };
    };
  };
}
