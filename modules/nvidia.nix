# Nvidia configuration for NixOS with Wayland and Hyprland support
# Import this module only if you have an Nvidia GPU
{ pkgs
, config
, ...
}:
let
  # Using beta driver for recent GPUs like RTX 4070
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.beta;
in
{
  # Video drivers configuration for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" "intel" ]; # Simplified - other modules are loaded automatically
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;
    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;
    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # Make sure to use the correct Bus ID values for your system!
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };



  # Enhanced graphics support
  hardware.graphics = {
    enable = true;
    package = nvidiaDriverChannel;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
      mesa
      egl-wayland
      vulkan-loader
      vulkan-validation-layers
      libva
    ];
  };

  # Additional useful packages
  environment.systemPackages = with pkgs; [
    vulkan-tools
    mesa-demos
    libva-utils # VA-API debugging tools
  ];
}
