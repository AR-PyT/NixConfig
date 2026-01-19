{ pkgs }:

pkgs.writeShellScriptBin "lock-session" ''
  if pgrep "caelestia" > /dev/null; then
      loginctl lock-session
  else
      swaylock
  fi
''
