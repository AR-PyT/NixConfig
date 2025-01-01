{ pkgs, ... }:

{
  # Enable networking
  networking.hostName = (import ../../../variables.nix) hostname;

  # Refer to https://man.archlinux.org/man/iwd.config.5 for more information
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        AddressRandomization = "network";
        EnableNetworkConfiguration = true;
      };
      Network = {
        EnableIPv6 = true;
      };
      Scan = {
        DisablePeriodicScan = true;
      };
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  environment.systemPackages = with pkgs; [
    iwgtk
    impala
  ];
}