{ lib, config, pkgs, ... }:

with lib;

let
  module-category = "services"; # Category the module falls in
  module-name = "filebrowser"; # Name of the module
  cfg = config.snowman.${module-category}.${module-name}; # Config path
in {
  # --- Set options
  options.snowman.${module-category}.${module-name} = {
    enable = mkEnableOption
      "Installs ${module-name} on the host and starts hosting the dataPath folder.";

    port = mkOption {
      type = types.int;
      description = "The port to serve the files on";
    };

    dataPath = mkOption {
      type = types.str;
      description = "The preauth key used for authentification with the server";
    };
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Make the tailscale command usable to users
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

    # Create a oneshot job to authenticate to Tailscale
    systemd.services.filebrowser = {
      description = "Setup and run Filebrowser";
      environment.HOME = "/var/lib/filebrowser";

      # Make sure tailscale is running before trying to connect to tailscale
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      # Set this service as a simple job
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
      };
      
      script = "
        cd ${cfg.dataPath}
        ${pkgs.filebrowser}/bin/filebrowser -p ${builtins.toString cfg.port} -a 0.0.0.0 -r ${cfg.dataPath}/root
      ";
    };
  };
}
