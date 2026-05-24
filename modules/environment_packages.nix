{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # System Utilities
    gsimplecal
    cliphist
    wl-clipboard
    brightnessctl
    usbutils
    lshw
    killall
    libnotify

    # Development Tools
    python313
    gcc
    clang
    cmake
    git
    neovim
    nix-tree
    vscode
    ninja

    # Terminal Utilities
    kitty
    fish
    btop
    htop
    ranger
    wget
    unzip
    unrar
    zip
    ripgrep
    tree
    cmatrix
    eza
    lolcat
    bat
    tree
    grim

    swappy
    chromium
    firefox
    remmina
    wpsoffice
    neovide
    slurp
    swaylock

    discord
    zoom-us
  ];
}
