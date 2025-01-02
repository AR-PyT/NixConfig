{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python312
    gcc
    clang
    cmake
  ];
}
