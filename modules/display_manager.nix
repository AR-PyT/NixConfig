{ pkgs
, ...
}: 
let
  inherit (import ../variables.nix) host username;
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = username;
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
      };
    };
  };
}
