{ 
  inputs, 
  nixpkgs,
  nixpkgs-unstable,
  home-manager, 
  ...
}:

let
  system = (import ../variables.nix).system;
  host = (import ../variables.nix).hostname;
  user = (import ../variables.nix).user;
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
  "${host}" = lib.nixosSystem {
    specialArgs = {
      inherit unstable;
      inherit system;
      inherit inputs;
      inherit user;
      inherit host;
    };
    modules = [
      inputs.stylix.nixosModules.stylix
      ./config.nix  # Handle basic system configuration

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        # home-manager.users.${user} = import ./home.nix;
      }
    ];
  };
}
