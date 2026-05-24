{ config, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages;
    # This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernelParams = [
      "quiet"
      "fbcon=nodefer"
    ];
  };
}
