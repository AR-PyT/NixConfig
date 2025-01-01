{ lib, pkgs }:
let
  themePath = "./theme_v1";
in
pkgs.stdenv.mkDerivation rec {
  pname = "theme_v1";
  version = "1.0.0";
  src = ./theme_v1.zip;
  nativeBuildInputs = [ pkgs.unzip ];
  buildInputs = [ pkgs.unzip pkgs.plymouth ];

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