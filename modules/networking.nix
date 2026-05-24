{ config, pkgs, options, host, ... }:
{
  networking = {
    networkmanager.enable = true;
    hostName = host;
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    firewall = {
      enable = true;
      checkReversePath = "loose"; # Important for reliable connectivity
      trustedInterfaces = [ "proton0" "tailscale0" ];
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
    nftables.enable = true;
  };
  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LANGUAGE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_COLLATE = "en_US.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  services.tailscale.enable = true;
  services.geoclue2.enable = true;

  environment.systemPackages = with pkgs; [
    protonvpn-gui
    tailscale
  ];
}
