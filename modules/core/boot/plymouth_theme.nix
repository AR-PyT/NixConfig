{ lib, pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "theme_v1";
  version = "1.0.0";

  src = pkgs.fetchgit {
    url = "git@abdul/AR-PyT/NixConfig.git";
    rev = "00a306cc1f76e1d26d4ce986b08645a5bbd28249";
    sha256 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  buildInputs = [ pkgs.plymouth ];

  installPhase = ''
    mkdir -p $out/share/plymouth/themes/theme_v1
    cp -r * $out/share/plymouth/themes/theme_v1
  '';

  meta = {
    description = "Plymouth Custom Theme";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}