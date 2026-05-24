{ pkgs }:

pkgs.writeShellScriptBin "lock-session" ''
  if pgrep "quickshell" > /dev/null; then
      loginctl lock-session
  else
      swaylock
  fi
''
