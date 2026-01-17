{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # System Utilities
    xfce.thunar
    gsimplecal
    cliphist
    brightnessctl
    usbutils
    lshw
    killall
    libnotify

    # Development Tools
    python311
    python311.withPackages
    (ps: with ps; [
      jupyter
    ])
    gcc
    clang
    cmake
    git
    neovim
    nix-tree
    vscode
    ninja
    texliveFull

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
    file-roller
    wpsoffice
    swaynotificationcenter
    neovide
    slurp

    discord
    zoom-us
  ];

  
}
