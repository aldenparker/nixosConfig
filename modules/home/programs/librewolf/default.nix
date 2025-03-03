{
  lib,
  config,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.librewolf; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.librewolf = {
    enable = mkEnableOption "Enables librewolf for the host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
      # Enable WebGL, cookies and history
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };
    };
  };
}
