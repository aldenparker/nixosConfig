{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.geany; # Config path
in {
  # --- Set options
  options.${namespace}.programs.geany = {
    enable = mkEnableOption "Enables geany for the host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      geany
    ];
    
    home.file.".config/geany" = {
      source = ./config;
      recursive = true;
    };
  };
}
