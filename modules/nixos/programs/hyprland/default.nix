{ lib, inputs, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.hyprland; # Config path
in {
  # --- Set options
  options.${namespace}.programs.hyprland = {
    enable = mkEnableOption "Enables hyprland for host, needed for home-manager module";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    services.xserver.enable = true;

    # Enable sddm
    services.xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    # Get swww and waypaper
    environment.systemPackages = [
      inputs.swww.packages.${pkgs.system}.swww
      pkgs.waypaper
    ];

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
  };
}
