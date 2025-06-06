{ pkgs }:

pkgs.writeShellScriptBin "wayland-statusbar-toggle" ''
    if pgrep "waybar" > /dev/null; then
        pkill waybar
    else
        waybar
    fi
''