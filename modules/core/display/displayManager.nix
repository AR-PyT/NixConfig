{ pkgs, ... }:

{
  services.displayManager = {
      sddm.enable = true;
      sddm.wayland.enable = true;
    };
  # Enable Display Manager
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
  #       user = "greeter";
  #     };
  #   };
  # };

  # environment.systemPackages = with pkgs; [
  #   greetd.tuigreet
  # ];
}
