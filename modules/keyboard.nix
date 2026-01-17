{ pkgs, ... }:

{
  services.xserver = {
    xkb.layout = "us";
    xkb.options = "terminate:ctrl_alt_bksp";
  };

  services.kanata = {
    # Power Button Setting
    logind.extraConfig = ''
      HandlePowerKey=ignore
    '';

    enable = true;
    keyboards = {
      internalKeyboard = {
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
            caps esc
            pp prev next f10
            lctrl lmet lalt ralt rmet rctrl
          )

          (defalias
            sap (layer-switch media-layer)
            sbl (layer-switch base)
          )

          (deflayer base
            esc caps
            pp prev next @sap
            lctrl lmet lalt ralt rmet rctrl
          )

          (deflayer media-layer
            esc caps
            lctrl lmet lalt @sbl
            XX XX XX XX XX XX
          )
        '';
      };
    };
  };
}
