{ pkgs, host, ... }:

let
  inherit (import ../hosts/${host}/variables.nix) terminal browser;
in
pkgs.writeShellScriptBin "list-hypr-bindings" ''
  yad --width=800 --height=650 \
  --center \
  --fixed \
  --title="Hyprland Keybindings" \
  --no-buttons \
  --list \
  --column=Key: \
  --column=Description: \
  --column=Command: \
  --timeout=90 \
  --timeout-indicator=right \
  " = Windows/Super" "Modifier Key, used for keybindings" "Doesn't really execute anything by itself." \
  "ALT + R" "Enter resize mode" "Use ESC to move to normal mode" \
  "ALT + M" "Enter move mode" "Use ESC to move to normal mode" \
  " + 1-0" "Move To Workspace 1 - 10" "workspace,X" \
  " + SHIFT + 1-0" "Move Focused Window To Workspace 1 - 10" "movetoworkspace,X" \
  " + SPACE" "Toggle Special Workspace" "togglespecialworkspace" \
  "ALT + TAB" "Move to previous workspace" "previous" \
  " + SHIFT + F" "Toggle float mode" "togglefloating" \
  " + T" "Terminal" "kitty" \
  " + B" "Launch firefox" "firefox" \
  " + SHIFT + B" "Launch qutebrowser" "qutebrowser" \
  " + R" "App Launcher" "rofi-launcher" \
  " + L" "Lock Screen" "hyprlock" \
  " + Q" "Kill Focused Window" "killactive" \
  " + F" "File Browser" "thunar" \
  " + SHIFT + I" "Toggle Split Direction" "togglesplit" \
  " + SHIFT + N" "Toggle SwayNC" "swaync-client -d" \
  " + SHIFT + R" "Reload SwayNC Styling" "swaync-client -rs" \
  " + Print" "Take Screenshot" "screenshot_to_clipboard" \
  " + W" "Search Websites Like Nix Packages" "web-search" \
  " + SHIFT + B" "Toggle Bluetooth" "bluetooth_toggle" \
  " + SHIFT + W" "Toggle Wifi" "wifi_toggle" \
  " + X" "Toggle Wayland Statusbar" "wayland-statusbar-toggle" \
  "CTRL + ALT + S" "Toggle Pipewire Sink" "speaker-toggle" \
  " + CTRL + Right" "Move to next workspace" "workspace,e+1" \
  " + CTRL + Left" "Move to previous workspace" "workspace,e-1" \
  ""
''
