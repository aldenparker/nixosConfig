{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.services.docker; # Config path
in
{
  # --- Set options
  options.${namespace}.services.docker = {
    enable = mkEnableOption "Enables docker for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;

    # Useful other development tools
    environment.systemPackages = with pkgs; [
      docker-compose # start group of containers for dev
    ];
  };
}
