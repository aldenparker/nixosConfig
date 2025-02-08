{ lib, config, pkgs, ... }:

with lib;

let
  module-type = "nx"; # home-manager (hm) vs nixos (nx)
  module-category =
    "services"; # category the module falls in, usually the name of the folder it is in
  module-name = "glance"; # Name of the module
  config-file = ./glance.yml; # Config path
in {
  # --- Set options
  options.snowman.${module-type}.${module-category}.${module-name} = {
    enable = mkEnableOption "Enables ${module-name} for host";
  };

  # --- Set configuration
  config = mkIf
    config.snowman.${module-type}.${module-category}.${module-name}.enable {
      # Install Glance
      environment.systemPackages = [ pkgs.unstable.glance ];

      # Enable and open up firewall
      networking.firewall = {
        enable = true;
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
          ExecStart = ''${pkgs.unstable.glance}/bin/glance --config ${config-file}'';
        wants = [ "network.target" ];
        };
      };
  };
}
