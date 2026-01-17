{ config, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    # This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" "kvm" "kvm_intel" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # kernelParams = [ "quiet" "splash" "use-simpledrm" "fbcon=nodefer" ];
    # blacklistedKernelModules = [ "kvm" "kvm_intel" ]; # For Virtual Box
    kernelParams = [ "quiet" "fbcon=nodefer" ];
  };
}
