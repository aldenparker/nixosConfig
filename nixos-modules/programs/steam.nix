{
  lib,
  config,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.steam; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.steam = {
    enable = mkEnableOption "Installs steam and needed gaming features";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    programs = {
      # Enable dependencies
      gamescope.enable = true;

      # Setup steam
      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
    };
  };
}
