{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.waybar; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.waybar = {
    enable = mkEnableOption "Installs and configures waybar";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      waybar
    ];

    home.file.".config/waybar" = {
      source = ./config;
      recursive = true;
    };
  };
}
