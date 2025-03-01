{
  lib,
  inputs,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.bundles.kde; # Config path
in
{
  # --- Set options
  options.${namespace}.bundles.kde = {
    enable = mkEnableOption "Enables kde for host and all basic desktop features";
    x11 = mkEnableOption "Enables x11 for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    ${namespace}.programs = {
      gdm.enable = true;

      kde = {
        enable = true;
        x11 = cfg.x11;
      };
    };
  };
}
