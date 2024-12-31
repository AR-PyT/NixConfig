{ pkgs, ... }:

{
  # Use Geoclue to adjust screen temperature based on location
  # Disable this if you find this feature annoying
  services.geoclue2.appConfig = {
      "gammastep" = {
        isAllowed = true;  # Disable here
        isSystem = false;
        users = [ "1000" ];  # These users are affected
      };
  };

  location.provider = "geoclue2";
  services.geoclue2.enable = true;
}