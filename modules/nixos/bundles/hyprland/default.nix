{ lib, inputs, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.bundles.hyprland; # Config path
in {
  # --- Set options
  options.${namespace}.bundles.hyprland = {
    enable = mkEnableOption "Enables hyprland for host and all basic desktop features, needed for home-manager module";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    ${namespace}.programs = {
      gdm.enable = true;
      hyprland.enable = true;
      swww.enable = true;
    };
  };
}
