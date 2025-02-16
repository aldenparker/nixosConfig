{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.bundles.hyprland; # Config path
in {
  # --- Set options
  options.${namespace}.bundles.hyprland = {
    enable = mkEnableOption "Configures hyprland and it's basic programs for the host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    ${namespace}.programs = {
      hyprland.enable = true;
      wofi.enable = true;
      kitty.enable = true;
    };
  };
}
