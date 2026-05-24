{ pkgs, ... }: {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$shiftMod" = "SUPER_SHIFT";

    bindl = [
      # Mapping common keys to actions
      ", Print, global, caelestia:screenshot" # Screenshot
      ", XF86MonBrightnessUp, global, caelestia:brightnessUp"
      ", XF86MonBrightnessDown, global, caelestia:brightnessDown"

      ",XF86KbdBrightnessUp, exec, brightnessctl --device='asus::kbd_backlight' set 1+" # Keyboard Brightness Up
      ",XF86KbdBrightnessDown, exec, brightnessctl --device='asus::kbd_backlight' set 1-" # Keyboard Brightness Down

      # Sound
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" # Mute/Unmute


      # Media
      ", XF86AudioPlay, global, caelestia:mediaToggle" # Play/Pause
      ", XF86AudioNext, global, caelestia:mediaNext" # Next Track
      ", XF86AudioPrev, global, caelestia:mediaPrev" # Previous Track
      ", XF86AudioStop, global, caelestia:mediaStop" # Stop
    ];

    bindle = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+" # Volume Up
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" # Volume Down
    ];

    bind =
      [
        "$shiftMod, d, movewindow, r" # Move window right
        "$shiftMod, a, movewindow, l" # Move window left
        "$shiftMod, w, movewindow, u" # Move window up
        "$shiftMod, s, movewindow, d" # Move window down

        # Switch workspaces
        "$mod,1, workspace, 1"
        "$mod,2, workspace, 2"
        "$mod,3, workspace, 3"
        "$mod,4, workspace, 4"
        "$mod,5, workspace, 5"
        "$mod,6, workspace, 6"
        "$mod,7, workspace, 7"
        "$mod,8, workspace, 8"
        "$mod,9, workspace, 9"
        "$mod,0, workspace, 10"

        "$mod,Tab, cyclenext" # Cycle next window
        "$shiftMod,Tab, bringactivetotop" # Bring active window to top
        "ALT,Tab, workspace, previous" # Switch to previous workspace
        "$shiftMod,Tab, bringactivetotop" # Bring active window to top
        "$shiftMod,F, togglefloating," # Toggle Floating

        # Switch item to workspace
        "$shiftMod,0, movetoworkspace, 10"
        "$shiftMod,1, movetoworkspace, 1"
        "$shiftMod,2, movetoworkspace, 2"
        "$shiftMod,3, movetoworkspace, 3"
        "$shiftMod,4, movetoworkspace, 4"
        "$shiftMod,5, movetoworkspace, 5"
        "$shiftMod,6, movetoworkspace, 6"
        "$shiftMod,7, movetoworkspace, 7"
        "$shiftMod,8, movetoworkspace, 8"
        "$shiftMod,9, movetoworkspace, 9"

        "$mod CONTROL, SPACE, togglespecialworkspace, info" # Special Workspace: Info
        ", XF86Launch1, togglespecialworkspace, work" # Special Workspace: Work
        "$mod ALT, SPACE, togglespecialworkspace, vpn" # Special Workspace: VPN
        "$mod, SPACE, togglespecialworkspace, utils" # Special Workspace: Utils

        "$shiftMod CONTROL, SPACE, movetoworkspace, special:info" # Move to Special Workspace: Info
        "$mod, XF86Launch1, movetoworkspace, special:work" # Move to Special Workspace: Work
        "$shiftMod ALT, SPACE, movetoworkspace, special:vpn" # Move to Special Workspace: VPN
        "$shiftMod, SPACE, movetoworkspace, special:utils" # Move to Special Workspace: Utils

        # Keybindings for usage        
        "$mod, T, exec, uwsm app -- ${pkgs.kitty}/bin/kitty" # Terminal (Kitty)
        "$shiftMod,T, exec, uwsm app -- ${pkgs.ghostty}/bin/ghostty" # Ghostty (terminal)
        "$mod, B, exec, uwsm app -- ${pkgs.firefox}/bin/firefox" # Browser (Firefox)
        "$mod, F, exec, uwsm app -- ${pkgs.xfce.thunar}/bin/thunar" # File Manager (Thunar)
        "$shiftMod, B, exec, uwsm app -- ${pkgs.chromium}/bin/chromium" # Browser (Chromium)
        "$shiftMod, D, exec, uwsm app -- ${pkgs.discord}/bin/discord" # Discord
        "$mod, N, exec, caelestia shell drawers toggle sidebar" # Toggle Sidebar
        "ALT, W, exec, wallsetter" # Wallsetter
        "$mod,Q, killactive," # Close window
        "$shiftMod,I, togglesplit," # Toggle Split
        "$mod, R, global, caelestia:launcher"
        "$shiftMod, E, exec, pkill fuzzel || caelestia emoji -p"

        # Keybindings for scripts
        "$mod, Print, exec, screenshot-to-clipboard" # Screenshot to clipboard
        "$mod, W, exec, web-search" # Web Search
        "$shiftMod, B, exec, bluetooth_toggle" # Bluetooth Toggle
        "$shiftMod, W, exec, wifi_toggle" # Wifi Toggle
        "$mod, X, exec, wayland-statusbar-toggle" # Toggle Statusbar
        "CONTROL ALT, S, exec, speaker-toggle" # Speaker Toggle
        "$shiftMod, L, exec, hibernate-session" # Hibernate Session
        "$mod, L, exec, lock-session" # Lock Session

        # Workspace navigation
        "$mod CONTROL, right, workspace, e+1" # Next Workspace
        "$mod CONTROL, left, workspace, e-1" # Previous Workspace

      ];

    bindm = [
      "$mod,mouse:272, movewindow" # Move Window (mouse)
      "$mod,mouse:273,resizewindow" # Resize Window (mouse)
    ];
  };
}
