{ lib, config, pkgs, ... }:

with lib;

let
  module-category = "services"; # Category the module falls in
  module-name = "podman"; # Name of the module
  cfg = config.snowman.${module-category}.${module-name}; # Config path
in {
  # --- Set options
  options.snowman.${module-category}.${module-name} = {
    enable = mkEnableOption "Enables ${module-name} for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true; # Create docker alias for podman
        defaultNetwork.settings.dns_enabled =
          true; # Requires that compose containers can talk to each other
      };
    };

    # Useful other development tools
    environment.systemPackages = with pkgs;
      [
        podman-compose # start group of containers for dev
      ];
  };
}
