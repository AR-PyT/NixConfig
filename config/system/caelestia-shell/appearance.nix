{ pkgs
, config
, ...
}:
let
  rounding = 10 + 10;
in
{
  home.packages = with pkgs; [
    papirus-icon-theme
  ];

  programs.caelestia.settings = {
    paths.sessionGif = ./session-gif-hacker-cat.gif;
    background.enabled = false;
    appearance = {
      transparency = {
        enable = true;
        base = 0.85;
        layers = 0.4;
      };
      font.family = {
        material = "Material Symbols Rounded";
        mono = "JetBrains Mono Nerd Font";
        sans = "Source Sans Pro";
      };
    };
    utilities = {
      enabled = true;
      maxToasts = 4;
      toasts = {
        audioInputChanged = true;
        audioOutputChanged = true;
        capsLockChanged = false;
        chargingChanged = true;
        configLoaded = false;
        dndChanged = true;
        gameModeChanged = true;
        numLockChanged = false;
        nowPlaying = false;
        kbLayoutChanged = false;
      };
    };
    border = {
      inherit rounding;
      thickness = 8;
    };
  };
}
