{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python311
    gcc
    clang
    cmake
  ];
}
