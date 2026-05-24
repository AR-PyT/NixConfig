{ pkgs }:

pkgs.writeShellScriptBin "hibernate-session" ''
  if pgrep "quickshell" > /dev/null; then
      loginctl lock-session && systemctl hibernate
  else
      swaylock & systemctl hibernate
  fi
''
