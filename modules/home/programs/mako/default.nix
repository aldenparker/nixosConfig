{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.mako; # Config path
in
{
  # TODO: add bar, screen lock
  # --- Set options
  options.${namespace}.programs.mako = {
    enable = mkEnableOption "Installs and configures mako";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mako
      libnotify # For notificaion send from terminal
    ];

    home.file.".config/mako" = {
      source = ./config;
      recursive = true;
    };
  };
}
