{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.hyprland; # Config path
in {
  # --- Set options
  options.${namespace}.programs.hyprland = {
    enable = mkEnableOption "Configures hyprland for the host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Install kitty for user
    home.packages = [
      pkgs.kitty
    ];

    wayland.windowManager.hyprland = {
      enable = true; # enable Hyprland
      # settings = {
        
      # };
    };
  };
}
