{ pkgs }:

pkgs.writeShellScriptBin "wayland-statusbar-toggle" ''
  if pgrep "quickshell" > /dev/null; then
      caelestia-shell kill
  else
      caelestia resizer
      caelestia shell -d
      caelestia scheme set -n custom
  fi
''
