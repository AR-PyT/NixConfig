{ config, pkgs, ... }: 
let
  inherit (import ../variables.nix) host;
in
{
  networking = {
    networkmanager = {
      enable = true;
      insertNameservers = [ "8.8.8.8" ];
    };
    hostName = host;
    firewall = {
      enable = true;
      checkReversePath = "loose";
      trustedInterfaces = [ "proton0" "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };

  time.timeZone = "Asia/Hong_Kong";
  time.hardwareClockInLocalTime = true;

  i18n.defaultLocale = "en_US.UTF-8";

  services.tailscale.enable = true;
  services.geoclue2.enable = true;

  environment.systemPackages = with pkgs; [
    protonvpn-gui
    tailscale
  ];
}