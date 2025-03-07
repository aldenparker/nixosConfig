{
  lib,
  config,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.gdm; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.gdm = {
    enable = mkEnableOption "Enables gdm for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Enable gdm
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.gdm.wayland = true;
  };
}
