# My shell configuration
{ pkgs
, lib
, config
, ...
}: {
  home.packages = with pkgs; [ bat ripgrep tldr sesh ];

  programs.fish = {
    enable = true;
    generateCompletions = true;
    interactiveShellInit = ''
    '';
    shellAliases = {
      sv = "sudo nvim";
      ns = "nix-shell";
      v = "nvim";
      cat = "bat";
      ls = "eza --icons";
      ll = "eza -lh --icons --grid --group-directories-first";
      la = "eza -lah --icons --grid --group-directories-first";
      ".." = "cd ..";
      slp = "hibernate-session";
    };
  };
}
