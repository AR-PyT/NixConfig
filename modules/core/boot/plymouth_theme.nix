{ lib, pkgs }:
let
  themePath = "./theme_v1";
in
pkgs.stdenv.mkDerivation rec {
  pname = "theme_v1";
  version = "1.0.0";
  src = themePath;
  buildInputs = [ pkgs.plymouth ];

  installPhase = ''
    mkdir -p $out/share/plymouth/themes/theme_v1
    cp -r $src/* $out/share/plymouth/themes/theme_v1
  '';

  meta = {
    description = "Plymouth Custom Theme";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}