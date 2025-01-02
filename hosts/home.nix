{ pkgs, ... }:
let
  inherit (import ../variables.nix) gitUsername gitEmail user;
in
{
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "24.11";

  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };

  xdg = {
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/jpeg" = [ "image-roll.desktop" "feh.desktop" ];
        "image/png" = [ "image-roll.desktop" "feh.desktop" ];
        "text/plain" = "nvim.desktop";
        "text/html" = "nvim.desktop";
        "text/csv" = "nvim.desktop";
        "application/pdf" = [ "wps-office-pdf.desktop" "firefox.desktop" ];
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/x-tar" = "org.gnome.FileRoller.desktop";
        "application/x-bzip2" = "org.gnome.FileRoller.desktop";
        "application/x-gzip" = "org.gnome.FileRoller.desktop";
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "x-scheme-handler/mailto" = [ "gmail.desktop" ];
        "audio/mp3" = "mpv.desktop";
        "audio/x-matroska" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/mp4" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "inode/directory" = "pcmanfm.desktop";
      };
    };
  };
}