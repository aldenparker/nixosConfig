{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.services.gitea; # Config path
in
{
  # --- Set options
  options.${namespace}.services.gitea = {
    enable = mkEnableOption "Enables Gitea for host";

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
      description = "Path to the Gitea database password";
    };

    dataPath = mkOption {
      type = types.str;
      description = "Path to Gitea data folder";
    };

    runnerToken = mkOption {
      type = types.str;
      default = "";
      description = "The token used by the runner for the Gitea instance. YOU WILL HAVE TO SET THIS AFTER YOU RUN GITEA THE FIRST TIME.";
    };
  };

  # --- Set configuration
  config = mkIf cfg.enable (mkMerge [
    # Merge all structures together
    # Add warning about the runner
    (mkIf (cfg.runnerToken == "") {
      warnings = [
        ''
          The runnerToken is not set for Gitea. 
          After setting up the Gitea server, add the runner by setting runnerToken to the token generated to enable this feature. 
        ''
      ];
    })

    # Add default configuration stuff
    {
      # Set firewall port
      networking = {
        firewall = {
          enable = true; # Enable the firewall (if not enabled elsewhere)
          allowedUDPPorts = [ cfg.port ];
        };
      };

      # Setup directory permisions for database path
      systemd.tmpfiles.rules = [ "d ${cfg.dataPath} 0755 gitea gitea" ];

      # Setup postgres database for gitea
      services.postgresql = {
        ensureDatabases = [ config.services.gitea.user ];
        ensureUsers = [
          {
            name = config.services.gitea.database.user;
            ensureDBOwnership = true;
          }
        ];
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
            ROOT_URL = "http://${cfg.domain}:${builtins.toString cfg.port}/";
            HTTP_PORT = cfg.port;
          };
        };

        stateDir = cfg.dataPath;
      };
    }

    # Setup gitea action runner only if token is set
    (mkIf (cfg.runnerToken != "") {
      services.gitea-actions-runner.instances."gitea-runner" = {
        enable = true;
        name = "Gitea Runner";
        url = "http://${cfg.domain}:${builtins.toString cfg.port}/";
        token = cfg.runnerToken;
        labels = [
          # TODO: add windows container and other options later
          "ubuntu-latest:docker://node:16-bullseye"
          "ubuntu-22.04:docker://node:16-bullseye"
          "ubuntu-18.04:docker://node:16-buster"
        ];
      };
    })
  ]);
}
