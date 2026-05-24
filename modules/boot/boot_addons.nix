{ pkgs, ... }:

{
  boot = {
    initrd.enable = true;
    initrd.systemd.settings.Manager.DefaultTimeoutStartSec = "5s";
    # Make /tmp a tmpfs
    tmp = {
      cleanOnBoot = true;
      tmpfsSize = "5GB";
    };
    initrd.availableKernelModules = [ "i915" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    consoleLogLevel = 3;

    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };
  # swapDevices = [{ device = "/dev/by-uuid/d5d94eef-5360-4551-af1b-3263e311719c"; }];
  # To avoid systemd services hanging on shutdown
  systemd.settings.Manager = { DefaultTimeoutStopSec = "10s"; };
}
