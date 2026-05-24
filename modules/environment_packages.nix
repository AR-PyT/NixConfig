{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # System
    cliphist
    wl-clipboard
    brightnessctl
    killall
    libnotify

    # Dev
    python313
    gcc
    cmake
    git
    neovim
    nix-tree
    ninja

    # Terminal
    kitty
    fish
    btop
    ranger
    wget
    unzip
    zip
    ripgrep
    tree
    eza
    bat
    grim
    slurp
    fzf
    fd
    jq
    rsync
    ncdu
    tldr

    # GUI
    swappy
    chromium
    wpsoffice
    neovide
    swaylock

    # Comm
    discord
    zoom-us
  ];
}