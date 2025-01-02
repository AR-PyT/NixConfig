{ pkgs, options, ... }:
let
  locale = (import ../../variables.nix).locale;
  timezone = (import ../../variables.nix).timezone;
in
{
  time.hardwareClockInLocalTime = true;
  time.timeZone = "${timezone}";
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  i18n.supportedLocales = [
    "${locale}"
  ];
  
  i18n.defaultLocale = "${locale}";

  i18n.extraLocaleSettings = {
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
}
