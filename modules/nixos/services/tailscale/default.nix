{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.services.tailscale; # Config path
  tailscale-args = if cfg.isExitNode then "--advertise-exit-node" else "";
in
{
  # --- Set options
  options.${namespace}.services.tailscale = {
    enable = mkEnableOption "Installs tailscale client on the host and authenticates to the server. Specifically used for headscale servers.";

    isExitNode = mkEnableOption "Makes this host an exit node";

    loginServer = mkOption {
      type = types.str;
      description = "The login server to use";
    };

    preAuthKey = mkOption {
      type = types.str;
      description = "The preauth key used for authentication with the server";
    };
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Make the tailscale command usable to users
    environment.systemPackages = [ pkgs.tailscale ];

    # Enable the tailscale service
    services.tailscale.enable = true;

    # Setup correct firewall rules
    networking = {
      firewall = {
        enable = true; # Enable the firewall (if not enabled elsewhere)
        trustedInterfaces = [ "tailscale0" ]; # Always allow traffic from your Tailscale network
        allowedUDPPorts = [
          config.services.tailscale.port
        ]; # Allow the Tailscale UDP port through the firewall
      };

      # Fix IPv6 for exit nodes
      nftables = mkIf cfg.isExitNode { enable = true; };
    };

    # Create a oneshot job to authenticate to Tailscale
    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";

      # Make sure tailscale is running before trying to connect to tailscale
      after = [
        "network-pre.target"
        "tailscale.service"
      ];
      wants = [
        "network-pre.target"
        "tailscale.service"
      ];
      wantedBy = [ "multi-user.target" ];

      # Set this service as a oneshot job
      serviceConfig.Type = "oneshot";

      # Have the job run this shell script
      script = with pkgs; ''
        # Wait for tailscaled to settle
        sleep 2

        # Check if we are already authenticated to tailscale
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
          exit 0
        fi

        # Otherwise authenticate with tailscale
        ${pkgs.tailscale}/bin/tailscale up --login-server=${cfg.loginServer} --auth-key=${cfg.preAuthKey} ${tailscale-args}
      '';
    };
  };
}
