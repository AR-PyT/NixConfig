{
  description = "General NIXOS for hyprland configuration v1.2";
  inputs = {
    # By default using stable version
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";  # For unstable packages as needed
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };

  outputs =
    inputs @ { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit inputs nixpkgs nixpkgs-unstable home-manager;  # Inherit Inputs
        }
      );
    };
}

