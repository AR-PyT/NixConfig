# Audio configuration for NixOS using PipeWire
{
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "10-disable-camera" = {
          "wireplumber.profiles" = { main."monitor.libcamera" = "disabled"; };
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
    pipewire
    pipewire-pulse
    pamixer
    playerctl
    mpv
    ffmpeg
    imv
    v4l-utils
  ];
}
