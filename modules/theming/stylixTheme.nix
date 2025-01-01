{ pkgs, ... }:
{
  stylix = {
    enable = true;
    image = ./hyprland_default.jpg;
    base16Scheme = {
      base00 = "1d2021"; # ----
      base01 = "383c3e"; # ---
      base02 = "53585b"; # --
      base03 = "6f7579"; # -
      base04 = "cdcdcd"; # +
      base05 = "d5d5d5"; # ++
      base06 = "dddddd"; # +++
      base07 = "e5e5e5"; # ++++
      base08 = "d72638"; # red
      base09 = "eb8413"; # orange
      base0A = "f19d1a"; # yellow
      base0B = "88b92d"; # green
      base0C = "1ba595"; # aqua/cyan
      base0D = "1e8bac"; # blue
      base0E = "be4264"; # purple
      base0F = "c85e0d"; # brown
    };
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };
}