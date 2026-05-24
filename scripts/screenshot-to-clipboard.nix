{ pkgs }:

pkgs.writeShellScriptBin "screenshot-to-clipboard" ''
  grim -g "$(slurp)" - | wl-copy -t image/png
  notify-send "Screenshot" "Screenshot copied to clipboard"
''
