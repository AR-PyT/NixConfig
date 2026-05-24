{ pkgs
, lib
, config
, username
, host
, ...
}:
let
  inherit (import ../variables.nix) gitUsername gitEmail configPath;
in
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  # Import Program Configurations
  imports = [
    ../config/programs
    ../config/system
  ];

  # Place Files Inside Home Directory
  home.file."Pictures/Wallpapers" = {
    source = ../config/wallpapers;
    recursive = true;
  };
  home.file.".config/lockscreen.jpg".source = ../config/wp1.jpg;
  home.file.".face.icon".source = ../config/face.jpg;
  home.file.".config/face.jpg".source = ../config/face.jpg;
  home.file.".config/lain.png".source = ../config/lain.png;
  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=/home/${username}/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=Ubuntu
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';
  home.file.".config/nixpkgs/config.nix".text = ''
    { allowUnfree = true; }'';


  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # Styling Options
  stylix.targets.gnome.enable = true;
  stylix.targets.gtk.enable = true;
  # gtk = {
  #   enable = lib.mkForce false;
  #   theme.name = lib.mkForce "Adwaita-dark";
  #   theme.package = lib.mkForce pkgs.gnome-themes-extra;
  #   iconTheme = {
  #     name = "Papirus-Dark";
  #     package = pkgs.papirus-icon-theme;
  #   };
  #   gtk3.extraConfig = {
  #     gtk-application-prefer-dark-theme = 1;
  #   };
  #   gtk4.extraConfig = {
  #     gtk-application-prefer-dark-theme = 1;
  #   };
  # };
  # qt = {
  #   enable = true;
  #   platformTheme = lib.mkDefault "gtk";
  #   style.name = lib.mkDefault "Adwaita-dark";
  # };
  # home.sessionVariables = {
  #   GTK_THEME = "Adwaita:dark";
  #   XDG_ICON_DIR = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
  # };

  # Scripts
  home.packages = [
    (import ../scripts/bluetooth-toggle.nix { inherit pkgs; })
    (import ../scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit host;
    })
    (import ../scripts/nvidia-offload.nix { inherit pkgs; })
    (import ../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../scripts/screenshootin.nix { inherit pkgs; })
    (import ../scripts/screenshot-to-clipboard.nix { inherit pkgs; })
    (import ../scripts/speaker-toggle.nix { inherit pkgs; })
    (import ../scripts/task-waybar.nix { inherit pkgs; })
    (import ../scripts/wallsetter.nix {
      inherit pkgs;
      inherit username;
    })
    (import ../scripts/wayland-statusbar-toggle.nix { inherit pkgs; })
    (import ../scripts/web-search.nix { inherit pkgs; })
    (import ../scripts/wifi-toggle.nix { inherit pkgs; })
    (import ../scripts/hibernate-session.nix { inherit pkgs; })
    (import ../scripts/lock-session.nix { inherit pkgs; })

    pkgs.papirus-icon-theme
  ];

  programs = {
    firefox.enable = true;
    gh.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
    kitty = {
      enable = true;
      package = pkgs.kitty;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
      };
      extraConfig = ''
        tab_bar_style fade
        tab_fade 1
        active_tab_font_style   bold
        inactive_tab_font_style bold

        # background_image /home/${username}/.config/lain.png
        # background_image_layout cscaled
        # background_tint 0.9
      '';
    };
    home-manager.enable = true;

  };
}
