{ pkgs, ... }:

{
  boot = {
    # Make /tmp a tmpfs
    tmp = {
      cleanOnBoot = true;
      tmpfsSize = "5GB";
    };

    boot.initrd.availableKernelModules = [ "i915" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    consoleLogLevel = 0;
  };
  # To avoid systemd services hanging on shutdown
  systemd.settings.Manager = { DefaultTimeoutStopSec = "10s"; };
}
