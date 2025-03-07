{
  lib,
  config,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.bundles.gnome; # Config path
in
{
  # --- Set options
  options.${namespace}.bundles.gnome = {
    enable = mkEnableOption "Enables gnome for host and all basic desktop features";
    x11 = mkEnableOption "Enables x11 for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    ${namespace}.programs = {
      gdm.enable = true;

      gnome = {
        enable = true;
        x11 = cfg.x11;
      };
    };
  };
}
