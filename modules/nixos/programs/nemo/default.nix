{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.nemo; # Config path
in {
  # --- Set options
  options.${namespace}.programs.nemo = {
    enable = mkEnableOption "Enables dolphin for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    services.gvfs.enable = true;

    # --- System packages (no config)
    environment.systemPackages = with pkgs; [
      nemo-with-extensions
    ];
  };
}
