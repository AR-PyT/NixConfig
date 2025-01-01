{ pkgs, ... }:

{
  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-font-patcher
    noto-fonts-emoji
    noto-fonts-color-emoji
    material-icons
  ];
}
