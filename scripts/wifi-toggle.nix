{ pkgs }:

pkgs.writeShellScriptBin "wifi-toggle" ''
    if iwgtk status | grep -q "connected"; then
        iwgtk disconnect
        notify-send "Wi-Fi" "Wi-Fi disabled"
    else
        iwgtk connect
        notify-send "Wi-Fi" "Wi-Fi enabled"
    fi
''
