{
  description = "General NIXOS for hyprland configuration v1.1";

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs =
    inputs @ { self, nixpkgs, unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      host = "nixos";
      user = "abdul";
    in
    {
      nixosConfigurations = {
        import ./hosts {
          inherit inputs nixpkgs unstable home-manager system host user;  # Inherit Inputs
        }
      };
    };
}

