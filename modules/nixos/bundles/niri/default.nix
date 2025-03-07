{
  lib,
  config,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.bundles.niri; # Config path
in
{
  # --- Set options
  options.${namespace}.bundles.niri = {
    enable = mkEnableOption "Enables niri for host and all basic desktop features";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    ${namespace}.programs = {
      gdm.enable = true;
      niri.enable = true;
    };
  };
}
