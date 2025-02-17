{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.swayc; # Config path
in {
  # --- Set options
  options.${namespace}.programs.swayc = {
    enable = mkEnableOption "Configures swayc for the host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      swaynotificationcenter
    ];
  };
}
