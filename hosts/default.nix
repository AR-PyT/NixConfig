{ 
  inputs, 
  nixpkgs,
  unstable,
  home-manager, 
  system, 
  host, 
  user,
  ...
}:

let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  pkgs-unstable = import unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in 
{
  ${host} = lib.nixosSystem {
    specialArgs = {
      inherit pkgs-unstable;
      inherit system;
      inherit inputs;
      inherit user;
      inherit host;
    };
    modules = [
      ./config.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.${user} = import ./home.nix;
      }
    ];
  }
}
