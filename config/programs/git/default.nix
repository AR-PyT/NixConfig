# Git configuration
{ config, ... }:
let
  inherit (import ../../../variables.nix) gitUsername gitEmail;
in
{
  programs.git = {
    enable = true;
    ignores = [
      ".cache/"
      ".DS_Store"
      ".idea/"
      "*.swp"
      "*.elc"
      "auto-save-list"
      ".direnv/"
      "node_modules"
      "result"
      "result-*"
    ];
    settings = {
      user.name = gitUsername;
      user.email = gitEmail;
      init.defaultBranch = "main";
    };
  };
}
