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
    
    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
