{ lib, config, pkgs, pkgs-unstable, ... }:
let
  terminal = (import ../../variables.nix).terminal;
  browser = (import ../../variables.nix).browser;
  user = (import ../../variables.nix).user;
in
{
  environment.systemPackages = with pkgs; [
    pkgs.${terminal}
    fish # Terminal Emulator
    btop # Resource Manager
    git # Version Control
    killall # Process Killer
    lshw # Hardware Config
    vim # Text Editor
    neovim # Text Editor
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
    pkgs.${browser} # Browser
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
}
