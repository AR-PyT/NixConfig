# Bluetooth configuration for NixOS
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ blueman ];
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;
}
