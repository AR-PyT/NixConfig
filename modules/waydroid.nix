{ config, pkgs-unstable, inputs, ... }: {
  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = inputs.nixpkgs-waydroid.legacyPackages.${pkgs-unstable.system}.waydroid-nftables;
  environment.systemPackages = with pkgs-unstable; [
    waydroid
  ];
}
