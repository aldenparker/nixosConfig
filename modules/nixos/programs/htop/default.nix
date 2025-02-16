{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.htop; # Config path
in {
  # --- Set options
  options.${namespace}.programs.htop = {
    enable = mkEnableOption "Enables htop for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    programs.htop = {
      enable = true;
      settings.show_cpu_temperature = 1;
    };
  };
}
