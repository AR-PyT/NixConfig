{ lib
, pkgs
, config
, ...
}: {
  config.stylix = {
    enable = true;
    # See https://tinted-theming.github.io/tinted-gallery/ for more schemes
    base16Scheme = {
      base00 = "1d2021"; # Default Background
      base01 = "383c3e"; # Lighter Background (Used for status bars, line number and folding marks)
      base02 = "53585b"; # Selection Background
      base03 = "6f7579"; # Comments, Invisibles, Line Highlighting
      base04 = "cdcdcd"; # Dark Foreground (Used for status bars)
      base05 = "d5d5d5"; # Default Foreground, Caret, Delimiters, Operators
      base06 = "dddddd"; # Light Foreground (Not often used)
      base07 = "e5e5e5"; # Light Background (Not often used)
      base08 = "d72638"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      base09 = "eb8413"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
      base0A = "f19d1a"; # Classes, Markup Bold, Search Text Background
      base0B = "88b92d"; # Strings, Inherited Class, Markup Code, Diff Inserted
      base0C = "1ba595"; # Support, Regular Expressions, Escape Characters, Markup Quotes
      base0D = "1e8bac"; # Functions, Methods, Attribute IDs, Headings, Accent color
      base0E = "be4264"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
      base0F = "c85e0d"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    };

    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono Nerd Font";
      };
      sansSerif = {
        package = pkgs.source-sans-pro;
        name = "Source Sans Pro";
      };
      serif = config.stylix.fonts.sansSerif;
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 12;
        desktop = 11;
        popups = 12;
        terminal = 15;
      };
    };

    polarity = "dark";
    image = ../config/wallpapers/wp4.png;
    opacity = {
      terminal = 0.8;
      inactive = 0.7;
      active = 0.9;
    };

  };
}
