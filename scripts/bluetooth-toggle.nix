{ pkgs }:

pkgs.writeShellScriptBin "bluetooth-toggle" ''
  if bluetoothctl show | grep -q "Powered: yes"; then
      bluetoothctl power off
      notify-send "Bluetooth" "Bluetooth disabled"
  else
      bluetoothctl power on
      notify-send "Bluetooth" "Bluetooth enabled"
  fi
''
