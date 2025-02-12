{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.services.postgres; # Config path
in {
  # --- Set options
  options.${namespace}.services.postgres = {
    enable = mkEnableOption
      "Enables postgres and sets database path for host. Use ensureDatabases and ensureUsers in other modules to create database for that module.";

    dataPath = mkOption {
      type = types.str;
      description = "Path used for the database";
    };
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Setup file permissions for dataPath
    systemd.tmpfiles.rules = [ "d ${cfg.dataPath} 0750 postgres postgres" ];

    # Setup postgres database
    services.postgresql = {
      enable = true;
      dataDir = cfg.dataPath;
    };
  };
}
