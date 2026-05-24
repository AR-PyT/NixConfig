{
  description = "General NIXOS for hyprland configuration v4.0";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # zen-browser = {
    #   url = "github:0xc000022070/zen-browser-flake";
    #   inputs = {
    #     # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
    #     # to have it up-to-date or simply don't specify the nixpkgs input
    #     nixpkgs.follows = "nixpkgs-unstable";
    #     home-manager.follows = "home-manager";
    #   };
    # };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # nvf.url = "github:notashelf/nvf";

    # nixpkgs-waydroid.url = "github:NixOS/nixpkgs/pull/455257/head";
  };

  outputs =
    { nixpkgs, unstable, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
      inherit (import ./variables.nix) host username;
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit (nixpkgs) lib;
            inherit system;
            inherit inputs;
          };
          modules = [
            ./${host}/config.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.backupCommand = "mv %s %s.bak.$(date +%s)";
              home-manager.users.${username} = import ./${host}/home.nix;
            }
          ];
        };
      };
    };
}
