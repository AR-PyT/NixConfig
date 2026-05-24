{ ... }:
{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./display_manager.nix
    ./fonts.nix
    ./hyprland.nix
    ./intel-drivers.nix
    ./keyboard.nix
    ./networking.nix
    ./nix.nix
    ./nvidia.nix
    ./utils.nix
    ./virtualization.nix
    ./boot
    
    ./environment_packages.nix
  ];
}
