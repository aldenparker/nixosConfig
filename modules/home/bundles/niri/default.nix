{
  lib,
  config,
  pkgs,
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
    enable = mkEnableOption "Enables niri and other needed modules like waybar";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    ${namespace}.programs = {
      niri.enable = true;
      waybar.enable = true;
    };
  };
}
