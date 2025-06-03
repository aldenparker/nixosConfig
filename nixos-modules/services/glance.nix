{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.services.glance; # Config path
in
{
  # --- Set options
  options.${namespace}.services.glance = {
    enable = mkEnableOption "Installs glance on host and runs it on startup";

    configPath = mkOption {
      type = types.str;
      description = "The path to the config file";
    };

    port = mkOption {
      type = types.int;
      description = "The port to serve on";
    };
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Install Glance
    environment.systemPackages = [ pkgs.glance ];

    # Enable and open up firewall (if not enabled elsewhere)
    networking.firewall = {
      enable = true; # Enable firewall if not enabled elsewhere
      allowedTCPPorts = [ cfg.port ];
    };

    # Create a service for glance
    systemd.services.glance = {
      description = "Automatic start for Glance";

      # Make connected to network first
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      # Simple startup
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${pkgs.glance}/bin/glance --config ${cfg.configPath}";
      };
    };
  };
}
