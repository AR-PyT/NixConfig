{
  lib,
  username,
  host,
  config,
  ...
}:

let
in
with lib;
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    extraConfig =
      concatStrings [
        ''
        exec-once = /nix/store/d5bki4k0jpnw5897kbnaclzmxrhdxc8c-dbus-1.14.10/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target
        env = XDG_CURRENT_DESKTOP, Hyprland
        env = XDG_SESSION_TYPE, wayland
        env = XDG_SESSION_DESKTOP, Hyprland
        env = GDK_BACKEND, wayland, x11
        env = CLUTTER_BACKEND, wayland
        env = QT_QPA_PLATFORM=wayland;xcb
        env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
        env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
        env = SDL_VIDEODRIVER, x11
        env = MOZ_ENABLE_WAYLAND, 1


        # Execute your favorite apps at launch
        exec-once = dbus-update-activation-environment --systemd --all
        exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        exec-once = killall -q swww;sleep .5 && swww init
        exec-once = killall -q waybar;sleep .5 && waybar
        exec-once = killall -q swaync;sleep .5 && swaync
        exec-once = nm-applet --indicator
        exec-once = lxqt-policykit-agent
        exec-once = sleep 1.5 && wallsetter

        # Set apps to special workspaces
        # exec-once = [workspace special:vpn silent] mullvad-gui
        exec-once = [workspace special:utils silent] blueman-manager
        exec-once = [workspace special:info silent] kitty btop
        # exec-once = [workspace special:ferdium silent] ferdium

        monitor=,preferred,auto,1

        # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
        input {
          kb_layout = us
          kb_options = terminate:ctrl_alt_bksp
          follow_mouse = 1
          touchpad {
            natural_scroll = true
            disable_while_typing = true
            scroll_factor = 0.8
          }
          sensitivity = 1 # -1.0 - 1.0, 0 means no modification.
          accel_profile = flat
          scroll_method = 2fg
        }

        general {
          gaps_in = 4
          gaps_out = 10
          border_size = 2
          layout = dwindle
          resize_on_border = true
          col.active_border = rgb(d72638) rgb(1ba595) 45deg
          col.inactive_border = rgb(383c3e)
        }

        windowrule = workspace special:ferdium, ^(Ferdium)$

        windowrule = noborder,^(wofi)$
        windowrule = center,^(wofi)$
        windowrule = float, nm-connection-editor|blueman-manager
        windowrule = float, swayimg|vlc|Viewnior|pavucontrol
        windowrule = float, nwg-look|qt5ct|mpv
        windowrule = float, zoom

        windowrulev2 = float, class:qutebrowser
        windowrulev2 = center, class:qutebrowser
        windowrulev2 = size 70% 70%, class:qutebrowser
        windowrulev2 = opacity 1 0.1, class:qutebrowser

        windowrulev2 = opacity 1.0 0.8, class:^(kitty)$

        windowrulev2 = opacity 0.95 0.8, class:^(firefox)$
        windowrulev2 = opacity 0.9 0.7, class:^(thunar)$

        gestures {
          workspace_swipe = true
          workspace_swipe_fingers = 3
          workspace_swipe_forever = true
        }
        misc {
          disable_hyprland_logo = true
          background_color = 0x24273a
          initial_workspace_tracking = 0
          mouse_move_enables_dpms = true
          key_press_enables_dpms = false
        }
        animations {
          enabled = yes
          bezier = wind, 0.05, 0.9, 0.1, 1.05
          bezier = winIn, 0.1, 1.1, 0.1, 1.1
          bezier = winOut, 0.3, -0.3, 0, 1
          bezier = liner, 1, 1, 1, 1
          animation = windows, 1, 6, wind, slide
          animation = windowsIn, 1, 6, winIn, slide
          animation = windowsOut, 1, 5, winOut, slide
          animation = windowsMove, 1, 5, wind, slide
          animation = border, 1, 1, liner
          animation = fade, 1, 10, default
          animation = workspaces, 1, 5, wind
        }
        decoration {
          rounding = 10
          blur {
              enabled = true
              size = 5
              passes = 3
              new_optimizations = on
              ignore_opacity = off
          }
          shadow {
              enabled = true
          }
        }
        plugin {
          hyprtrails {
          }
        }
        dwindle {
          pseudotile = true
          preserve_split = true
          smart_split = true
        }
        binds {
          workspace_back_and_forth = true
          allow_workspace_cycles = true
        }

        # See https://wiki.hyprland.org/Configuring/Keywords/ for more
        $mainMod = SUPER

        # Creating and switching between submaps for easier mangement
        # Resize Windows
        bind = ALT, R, submap, resize

        submap = resize
        binde = , right, resizeactive, 10 0
        binde = , left, resizeactive, -10 0
        binde = , up, resizeactive, 0 -10
        binde = , down, resizeactive, 0 10

        bind = , escape, submap, reset
        submap = reset

        # Move Windows
        bind = ALT, M, submap, move

        submap = move
        bind = , d, movewindow, r
        bind = , a, movewindow, l
        bind = , w, movewindow, u
        bind = , s, movewindow, d
        bind = , escape, submap, reset

        submap = reset

        bind = $mainMod SHIFT, d, movewindow, r
        bind = $mainMod SHIFT, a, movewindow, l
        bind = $mainMod SHIFT, w, movewindow, u
        bind = $mainMod SHIFT, s, movewindow, d

        # Mappind common keys to actions
        bind = ,Print,exec,screenshootin
        bind = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
        bind = ,XF86MonBrightnessUp,exec,brightnessctl set +5%
        binde = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        binde = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        bind = ,XF86KbdBrightnessUp,exec,brightnessctl --device='asus::kbd_backlight' set 1+
        bind = ,XF86KbdBrightnessDown,exec,brightnessctl --device='asus::kbd_backlight' set 1-
        bind = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        bind = ,XF86AudioPlay, exec, playerctl play-pause
        bind = ,XF86AudioStop, exec, playerctl play-pause
        bind = ,XF86AudioNext, exec, playerctl next
        bind = ,XF86AudioPrev, exec, playerctl previous


        # Switch workspaces
        bind = $mainMod,1,workspace,1
        bind = $mainMod,2,workspace,2
        bind = $mainMod,3,workspace,3
        bind = $mainMod,4,workspace,4
        bind = $mainMod,5,workspace,5
        bind = $mainMod,6,workspace,6
        bind = $mainMod,7,workspace,7
        bind = $mainMod,8,workspace,8
        bind = $mainMod,9,workspace,9
        bind = $mainMod,0,workspace,10

        bind = CTRL,Tab,cyclenext
        bind = CTRL,Tab,bringactivetotop
        bind = ALT,Tab,workspace,previous
        bind = $mainMod SHIFT,F,togglefloating,

        # Switch item to workspace
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9

        # Special workspace
        bind = $mainMod CONTROL, SPACE, togglespecialworkspace, info
        bind = $mainMod SHIFT, SPACE, togglespecialworkspace, utils
        bind = $mainMod ALT, SPACE, togglespecialworkspace, vpn
        bind = $mainMod, SPACE, togglespecialworkspace, work
        bind = , XF86Launch1, togglespecialworkspace, ferdium

        bind = $mainMod SHIFT, 0, movetoworkspace, special:work

        bindm = $mainMod,mouse:272,movewindow
        bindm = $mainMod,mouse:273,resizewindow

        # Keybindings for usage
        bind = $mainMod, T, exec, kitty
        bind = $mainMod, B, exec, firefox
        bind = $mainMod SHIFT, B, exec, qutebrowser
        bind = $mainMod, R, exec, rofi-launcher
        bind = $mainMod SHIFT, D, exec, discord
        bind = $mainMod, L, exec, hyprlock
        bind = ALT, W, exec, wallsetter
        bind = $mainMod, Q, killactive,
        bind = $mainMod, F, exec, thunar
        bind = $mainMod SHIFT, I, togglesplit,
        bind = $mainMod SHIFT, N, exec, swaync-client -d
        bind = $mainMod SHIFT, R, exec, swaync-client -rs
        bind = $mainMod, XF86Launch1, exec, ferdium

        # Keybindings for scripts
        bind = $mainMod, Print, exec, screenshot-to-clipboard
        bind = $mainMod, W, exec, web-search
        bind = $mainMod SHIFT, B, exec, bluetooth_toggle
        bind = $mainMod SHIFT, W, exec, wifi_toggle
        bind = $mainMod, X, exec, wayland-statusbar-toggle
        bind = CONTROL ALT, S, exec, speaker-toggle

        bind = $mainMod CONTROL,right,workspace,e+1
        bind = $mainMod CONTROL,left,workspace,e-1
        ''
      ];
  };
}
