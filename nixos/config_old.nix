{ config, pkgs, options, lib, inputs, pkgs-unstable, ... }:
let
  inherit (import ../variables.nix) host username;
in
{
  imports = [
    ./hardware.nix
    ./users.nix
    ../modules/nvidia-drivers.nix
    ../modules/nvidia-prime-drivers.nix
    ../modules/intel-drivers.nix
    ../modules/local-hardware-clock.nix
    ../modules/keyboard.nix
    ../modules/boot
  ];


}
