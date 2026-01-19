{ pkgs }:

pkgs.writeShellScriptBin "hibernate-session" ''
  if pgrep "caelestia" > /dev/null; then
      loginctl lock-session && systemctl hibernate
  else
      swaylock && systemctl hibernate
  fi
''
