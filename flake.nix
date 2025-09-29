{
  description = "General NIXOS for hyprland configuration v2.1";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix/release-24.11";

    # base16-nix.url = "github:SenchoPens/base16.nix";
    # base16-nix.flake = false;
    # stylix.inputs.base16.follows = "base16-nix";
    fine-cmdline = {
      url = "github:VonHeikemen/fine-cmdline.nvim";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      inherit (import ./variables.nix) host username;
      pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit (nixpkgs) lib;
	          inherit system;
            inherit inputs;
            inherit pkgs-unstable;
          };
          modules = [
            ./${host}/config.nix
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager {
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./${host}/home.nix;
            }
          ];
        };
      };
    };
}
