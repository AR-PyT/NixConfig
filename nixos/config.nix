{ config, ... }: {
  imports = [
    ./hardware.nix
    ./users.nix
    ../modules

  ];

  system.stateVersion = "25.11";
}
