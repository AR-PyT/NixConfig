{ config, pkgs, ... }: {

  virtualisation = {
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };

    docker = {
      package = pkgs.docker_25;
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      daemon.settings = {
        features.cdi = true;  # Enable CDI for GPU support
      };
    };
  };
  hardware.nvidia-container-toolkit.enable = true;

  boot.blacklistedKernelModules = [ "kvm" "kvm_intel" ]; # Required for VirtualBox Compatibility
}
