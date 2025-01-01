{ lib, config, pkgs, pkgs-unstable, ... }:
let
  terminal = (import ../../variables.nix).terminal;
  browser = (import ../../variables.nix).browser;
  user = (import ../../variables.nix).user;
in
{
  environment.systemPackages = with pkgs; [
    "${terminal}"
    fish # Terminal Emulator
    btop # Resource Manager
    git # Version Control
    killall # Process Killer
    lshw # Hardware Config
    vim # Text Editor
    nvim # Text Editor
    nix-tree # Browse Nix Store
    pciutils # Manage PCI
    ranger # File Manager
    smartmontools # Disk Health
    wget # Retriever
    xdg-utils # Environment integration
    vscode # Code Editor

    # Video/Audio
    feh # Image Viewer
    mpv # Media Player
    vlc # Media Player

    # Apps
    appimage-run # Runs AppImages on NixOS
    "${browser}" # Browser
    remmina # XRDP & VNC Client

    # File Management
    file-roller # Archive Manager
    pcmanfm # File Browser
    p7zip # Zip Encryption
    rsync # Syncer - $ rsync -r dir1/ dir2/
    unzip # Zip Files
    unrar # Rar Files
    wpsoffice # Office
    zip # Zip
    
    # Linux commands
    ripgrep # Search
    tree # Directory
    cmatrix
    cowsay
    eza
  ] ++
  (with pkgs-unstable; [
    # Packages from unstable channel
  ]);

  home-manager.users.${user} = {
    home = {
      stateVersion = "24.11";
    };
    programs = {
      home-manager.enable = true;
    };
    xdg = {
      mime.enable = true;
      mimeApps = lib.mkIf (config.gnome.enable == false) {
        enable = true;
        defaultApplications = {
          "image/jpeg" = [ "image-roll.desktop" "feh.desktop" ];
          "image/png" = [ "image-roll.desktop" "feh.desktop" ];
          "text/plain" = "nvim.desktop";
          "text/html" = "nvim.desktop";
          "text/csv" = "nvim.desktop";
          "application/pdf" = [ "wps-office-pdf.desktop" "firefox.desktop" ];
          "application/zip" = "org.gnome.FileRoller.desktop";
          "application/x-tar" = "org.gnome.FileRoller.desktop";
          "application/x-bzip2" = "org.gnome.FileRoller.desktop";
          "application/x-gzip" = "org.gnome.FileRoller.desktop";
          "x-scheme-handler/http" = [ "firefox.desktop" ];
          "x-scheme-handler/https" = [ "firefox.desktop" ];
          "x-scheme-handler/about" = [ "firefox.desktop" ];
          "x-scheme-handler/unknown" = [ "firefox.desktop" ];
          "x-scheme-handler/mailto" = [ "gmail.desktop" ];
          "audio/mp3" = "mpv.desktop";
          "audio/x-matroska" = "mpv.desktop";
          "video/webm" = "mpv.desktop";
          "video/mp4" = "mpv.desktop";
          "video/x-matroska" = "mpv.desktop";
          "inode/directory" = "pcmanfm.desktop";
        };
      };
    };
  };
}
