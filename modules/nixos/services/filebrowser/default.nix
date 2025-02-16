{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.services.filebrowser; # Config path
in {
  # --- Set options
  options.${namespace}.services.filebrowser = {
    enable = mkEnableOption
      "Installs filebrowser on the host and starts hosting the dataPath folder.";

    port = mkOption {
      type = types.int;
      description = "The port to serve the files on";
    };

    dataPath = mkOption {
      type = types.str;
      description = "The data path for the files";
    };
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Install filebrowser
    environment.systemPackages = [ pkgs.filebrowser ];

    # Setup correct firewall rules
    networking.firewall = {
      enable = true; # Enable the firewall (if not enabled elsewhere)
      allowedTCPPorts = [ cfg.port ];
    };

    # Setup directory for dataPath
    systemd.tmpfiles.rules = [
      "d ${cfg.dataPath} 0755 root root"
      "d ${cfg.dataPath}/root 0755 root root"
    ];

    # Create systemd service for filebrowser
    systemd.services.filebrowser = {
      description = "Setup and run Filebrowser";
      environment.HOME = "/var/lib/filebrowser";

      # Make sure filebrowser runs after network is online
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      # Set this service as a simple job
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
      };

      # Script to run
      script = ''
        cd ${cfg.dataPath}
        ${pkgs.filebrowser}/bin/filebrowser -p ${builtins.toString cfg.port} -a 0.0.0.0 -r ${cfg.dataPath}/root
      '';
    };
  };
}
