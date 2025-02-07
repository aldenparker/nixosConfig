{ lib, config, pkgs, secrets, ... }:

with lib;

let
  module-type = "nx"; # home-manager (hm) vs nixos (nx)
  module-category = "services"; # category the module falls in, usually the name of the folder it is in
  module-name = "tailscale"; # Name of the module
in {
  # --- Set options
  options.snowman.${module-type}.${module-category}.${module-name} = {
    enable = mkEnableOption "Enables ${module-name} for host";
    isExitNode = mkEnableOption "Makes this host an exit node";
  };

  # --- Set configuration
  config = mkIf config.snowman.${module-type}.${module-category}.${module-name}.enable {
    # Make the tailscale command usable to users
    environment.systemPackages = [ pkgs.tailscale ];

    # Enable the tailscale service
    services.tailscale.enable = true;

    # Setup correct firewall rules
    networking = {
      firewall = {
        # Enable the firewall (if not enabled elsewhere)
        enable = true;

        # Always allow traffic from your Tailscale network
        trustedInterfaces = [ "tailscale0" ];

        # Allow the Tailscale UDP port through the firewall
        allowedUDPPorts = [ config.services.tailscale.port ];

        # Lets you SSH in over tailscale
        allowedTCPPorts = [ 22 ];
      };

      # Fix IPv6 for exit nodes
      nftables = mkIf config.snowman.${module-type}.${module-category}.${module-name}.isExitNode {
        enable = true;
      };
    };

    # Create a oneshot job to authenticate to Tailscale
    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";

      # Make sure tailscale is running before trying to connect to tailscale
      after = [ "network-pre.target" "tailscale.service" ];
      wants = [ "network-pre.target" "tailscale.service" ];
      wantedBy = [ "multi-user.target" ];

      # Set this service as a oneshot job
      serviceConfig.Type = "oneshot";

      # Have the job run this shell script
      script = 
        if config.snowman.${module-type}.${module-category}.${module-name}.isExitNode
        then with pkgs; ''
          # Wait for tailscaled to settle
          sleep 2

          # Check if we are already authenticated to tailscale
          status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
          if [ $status = "Running" ]; then # if so, then do nothing
            exit 0
          fi

          # Otherwise authenticate with tailscale
          ${tailscale}/bin/tailscale up --login-server=${secrets.tailscale.loginServer} --auth-key=${secrets.tailscale.authkey} --advertise-exit-node
        ''
        else with pkgs; ''
          # Wait for tailscaled to settle
          sleep 2

          # Check if we are already authenticated to tailscale
          status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
          if [ $status = "Running" ]; then # if so, then do nothing
            exit 0
          fi

          # Otherwise authenticate with tailscale
          ${tailscale}/bin/tailscale up --login-server=${secrets.tailscale.loginServer} --auth-key=${secrets.tailscale.authkey}
      '';
    };
  };
}
