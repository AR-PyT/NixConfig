{ config, ... }: {

  virtualisation = {
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };

    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  boot.blacklistedKernelModules = [ "kvm" "kvm_intel" ]; # Required for VirtualBox Compatibility
}
