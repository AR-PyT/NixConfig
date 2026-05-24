# Caelestia Shell Home Manager Configuration
# See https://github.com/caelestia-dots/shell
{ pkgs
, inputs
, ...
}: {
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
    ./bar.nix
    ./launcher.nix
    ./appearance.nix
    ./scheme.nix
  ];

  programs.caelestia = {
    enable = true;
    systemd.enable = false;
    settings = {
      osd.enabled = false;
      services.weatherLocation = "Hong Kong";
      services.useFahrenheit = false;
      dashboard.showOnHover = false;
      background.enable = false;
      general = {
        apps = {
          terminal = [ "ghostty" ];
          audio = [ "pavucontrol" ];
          explorer = [ "thunar" ];
        };
        idle = {
          timeouts = [ ];
        };
      };
    };
    cli = {
      enable = true;
      settings.theme = {
        enableTerm = false;
        enableDiscord = false;
        enableSpicetify = false;
        enableBtop = false;
        enableCava = false;
        enableHypr = false;
        enableGtk = false;
        enableQt = false;
      };
    };
  };

  home.packages = with pkgs; [
    gpu-screen-recorder
  ];

  services.cliphist = {
    enable = true;
    allowImages = true;
  };
}
