{ pkgs, ... }:

{
  # USB Automounting
  services.gvfs.enable = true;

  # Enable USB-specific packages
  environment.systemPackages = with pkgs; [
    usbutils
  ];
}
