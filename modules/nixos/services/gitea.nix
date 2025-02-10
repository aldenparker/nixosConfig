{ lib, config, ... }:

with lib;

let
  module-category = "services"; # Category the module falls in
  module-name = "gitea"; # Name of the module
  cfg = config.snowman.${module-category}.${module-name}; # Config path
in {
  # --- Set options
  options.snowman.${module-category}.${module-name} = {
    enable = mkEnableOption "Enables ${module-name} for host";
    
    siteName = mkOption {
      type = types.str;
      description = "Name for the site";
    };

    domain = mkOption {
      type = types.str;
      description = "Domain used for the site";
    };

    port = mkOption {
      type = types.int;
      description = "The port to serve the git server at";
    };

    passwordFile = mkOption {
      type = types.str;
      description = "Path to the Gitea databse password";
    };

    dataPath = mkOption {
      type = types.str;
      description = "Path to Gitea data folder";
    };

    dbDataPath = mkOption {
      type = types.str;
      description = "Path for the postgres databse used for Gitea";
    };
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Set firewall port 
    networking = {
      firewall = {
        enable = true; # Enable the firewall (if not enabled elsewhere)
        allowedUDPPorts = [ cfg.port ];
      };
    };

    # Setup postgres database for gitea
    services.postgresql = {
      ensureDatabases = [ config.services.gitea.user ];
      ensureUsers = [
        {
          name = config.services.gitea.database.user;
          ensureDBOwnership = true;
        }
      ];

      dataDir = cfg.dbDataPath;
    };

    # Setup gitea
    services.gitea = {
      enable = true;
      appName = cfg.siteName;

      database = {
        type = "postgres";
        passwordFile = cfg.passwordFile;
      };

      settings = {
        server = {
          DOMAIN = cfg.domain;
          ROOT_URL = "http://${cfg.domain}:8000/";
          HTTP_PORT = cfg.port;
        };

        service = {
          DISABLE_REGISTRATION = true;
        };
      };

      stateDir = cfg.dataPath;
      useWizard = true; # For initial setup
    };
  };
}
