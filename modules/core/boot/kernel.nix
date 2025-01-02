{ config, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_6_6;
    # This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

    kernelParams = [ "quiet" ];
  };
}
