{ 
  inputs, 
  nixpkgs,
  nixpkgs-unstable,
  stylix,
  ...
}:

let
  inherit (import ../variables.nix)
    system
    hostname
    user
  ;
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in 
{
  "${hostname}" = lib.nixosSystem {
    specialArgs = {
      inherit unstable;
      inherit system;
      inherit inputs;
      inherit user;
      inherit hostname;
    };
    modules = [
      inputs.stylix.nixosModules.stylix
      ./config.nix  # Handle basic system configuration
    ];
  };
}
