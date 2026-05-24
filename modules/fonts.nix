# Fonts configuration for NixOS
{ pkgs, ... }: {
  fonts = {
    packages = with pkgs; [
      noto-fonts              # Base Noto: massive Unicode coverage for Latin/Greek/Cyrillic
      noto-fonts-cjk-sans     # Chinese/Japanese/Korean
      noto-fonts-color-emoji  # Emoji support (system default)
      nerd-fonts.fira-code    # Terminal font with icons
      nerd-fonts.meslo-lg     # Alternative terminal font
      dejavu_fonts            # Fallback font, good metric compatibility
    ];

    enableDefaultPackages = false;
  };
}
