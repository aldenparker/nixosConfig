{ lib, inputs, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.swww; # Config path
in {
  # --- Set options
  options.${namespace}.programs.swww = {
    enable = mkEnableOption "Enables swww for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Get swww and waypaper
    environment.systemPackages = [
      inputs.swww.packages.${pkgs.system}.swww
      pkgs.waypaper
    ];
  };
}
