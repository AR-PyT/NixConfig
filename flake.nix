{
  description = "General NIXOS for hyprland configuration v1.2";
  inputs = {
    # By default using stable version
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";  # For unstable packages as needed
    stylix.url = "github:danth/stylix";
  };

  outputs =
    inputs @ { self, nixpkgs, nixpkgs-unstable, ... }:
    let
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit inputs nixpkgs nixpkgs-unstable stylix;  # Inherit Inputs
        }
      );
    };
}

