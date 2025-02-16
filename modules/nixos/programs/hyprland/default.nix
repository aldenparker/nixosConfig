{ lib, inputs, config, pkgs, namespace, ... }:

with lib;

let
  #hyprland-pkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  cfg = config.${namespace}.programs.hyprland; # Config path
in {
  # --- Set options
  options.${namespace}.programs.hyprland = {
    enable = mkEnableOption "Enables hyprland for host, needed for home-manager module";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Enable sddm
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    # Get swww and waypaper
    environment.systemPackages = [
      inputs.swww.packages.${pkgs.system}.swww
      pkgs.waypaper
    ];

    # hardware.graphics = {
    #   package = hyprland-pkgs.mesa.drivers;

    #   driSupport32Bit = true;
    #   package32 = hyprland-pkgs.pkgsi686Linux.mesa.drivers;
    # };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      # set the flake package
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # make sure to also set the portal package, so that they are in sync
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };
}
