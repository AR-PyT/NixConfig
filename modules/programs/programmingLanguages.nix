{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (python312Full.withPackages(ps: with ps; [ numpy requests]))
    gcc
    clang
    cmake
  ];
}
