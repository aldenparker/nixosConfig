{ lib, inputs, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.gdm; # Config path
in {
  # --- Set options
  options.${namespace}.programs.gdm = {
    enable = mkEnableOption "Enables gdm for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    services.xserver.enable = true;
    
    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable gdm
    services.xserver.displayManager.gdm.enable = true;
  };
}
