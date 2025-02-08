{ lib, config, pkgs, ... }:

with lib;

let
  module-category = "services"; # Category the module falls in
  module-name = "glance"; # Name of the module
  cfg = config.snowman.${module-category}.${module-name}; # Config path
in {
  # --- Set options
  options.snowman.${module-category}.${module-name} = {
    enable = mkEnableOption "Installs glance on host and runs it on startup";

    configPath = mkOption {
      type = lib.types.str;
      default = ""; # Need to define path or else won't run
      description = "The path to the config file";
    };
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Install Glance
    environment.systemPackages = [ pkgs.unstable.glance ];

    # Enable and open up firewall (if not enabled elsewhere)
    networking.firewall = {
      enable = true; # Enable firewall if not enabled elsewhere
      allowedTCPPorts = [ 80 ]; # Serving on port 80
    };

    # Create a service for glance
    systemd.services.glance = {
      description = "Automatic start for Glance";

      # Make connected to netowrk first
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.unstable.glance}/bin/glance --config ${cfg.configPath}";
      };
    };
  };
}
