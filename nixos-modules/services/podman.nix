{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.services.podman; # Config path
in
{
  # --- Set options
  options.${namespace}.services.podman = {
    enable = mkEnableOption "Enables podman for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true; # Requires that compose containers can talk to each other
      };
    };

    # Useful other development tools
    environment.systemPackages = with pkgs; [
      podman-compose # start group of containers for dev
    ];
  };
}
