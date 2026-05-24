# Fzf is a general-purpose command-line fuzzy finder.
{ config
, lib
, ...
}:
let
  accent = "#1e8bac";
  foreground = "#d5d5d5";
  muted = "#6f7579";
in
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = lib.mkForce {
      "fg+" = accent;
      "bg+" = "-1";
      "fg" = foreground;
      "bg" = "-1";
      "prompt" = muted;
      "pointer" = accent;
    };
    defaultOptions = [
      "--margin=1"
      "--layout=reverse"
      "--border=none"
      "--info='hidden'"
      "--header=''"
      "--prompt='/ '"
      "-i"
      "--no-bold"
    ];
  };
}
