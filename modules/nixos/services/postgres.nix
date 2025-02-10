{ lib, config, ... }:

with lib;

let
  module-category = "services"; # Category the module falls in
  module-name = "postgres"; # Name of the module
  cfg = config.snowman.${module-category}.${module-name}; # Config path
in {
  # --- Set options
  options.snowman.${module-category}.${module-name} = {
    enable = mkEnableOption
      "Enables ${module-name} and sets database path for host. Use ensureDatabases and ensureUsers in other modules to create databse for that module.";

    dataPath = mkOption {
      type = types.str;
      description = "Path used for the database";
    };
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Setup file permisions for dataPath
    systemd.tmpfiles.rules = [ "d ${cfg.dataPath} 0750 postgres postgres" ];

    # Setup postgres database
    services.postgresql = {
      enable = true;
      dataDir = cfg.dataPath;
    };
  };
}
