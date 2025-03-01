{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.drivers.cuda; # Config path
in
{
  # --- Set options
  options.${namespace}.drivers.cuda = {
    enable = mkEnableOption "Enables nvidia drivers with cuda for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Enable nvidia drivers
    ${namespace}.drivers.nvidia.enable = true;

    environment.systemPackages = [
      pkgs.cudaPackages.cudatoolkit
    ];
  };
}
