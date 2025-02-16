{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.wofi; # Config path
in {
  # --- Set options
  options.${namespace}.programs.wofi = {
    enable = mkEnableOption "Configures wofi for the host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # App runner
    programs.wofi = {
      enable = true;
    };
  };
}
