{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.kitty; # Config path
in {
  # --- Set options
  options.${namespace}.programs.kitty = {
    enable = mkEnableOption "Enables kitty terminal for the host";

    configFolder = mkOption {
      type = types.path;
      default = "/";
      description = "Config folder to use, will be managed by home-manager";
    };
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Install for user
    home.packages = [
      pkgs.kitty
    ];

    # Copy kitty config to the config folder
    home.file.".config/kitty" = mkIf (cfg.configFolder != "/") {
      source = cfg.configFolder;
      recursive = true;
    };
  };
}
