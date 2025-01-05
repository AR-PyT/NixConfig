{
  description = "General NIXOS for hyprland configuration v2.1";
  inputs = {
    # By default will use the stable verson (24.11)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; 
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    fine-cmdline = {
      url = "github:VonHeikemen/fine-cmdline.nvim";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      host = "nixos";
      username = "abdul";
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit (nixpkgs) lib;
	          inherit system;
            inherit inputs;
            inherit username;
            inherit host;
          };
          modules = [
            # {
              # nixpkgs.overlays = [
              #   (final: prev: {
              #     plymouth = prev.plymouth.overrideAttrs ({ src, ... }: {
              #       version = "24.004.60-unstable-2024-08-28";

              #       src = src.override {
              #         rev = "ea83580a6d66afd2b37877fc75248834fe530d99";
              #         hash = "sha256-GQzf756Y26aCXPyZL9r+UW7uo+wu8IXNgMeJkgFGWnA=";
              #       };
              #     });
              #   })
              # ];
            # }
            ./hosts/${host}/config.nix
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager {
              home-manager.extraSpecialArgs = {
                inherit username;
                inherit inputs;
                inherit host;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./hosts/${host}/home.nix;
            }
          ];
        };
      };
    };
}
