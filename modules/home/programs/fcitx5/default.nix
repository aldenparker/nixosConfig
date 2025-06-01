{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.fcitx5; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.fcitx5 = {
    enable = mkEnableOption "Enables fcitx5 for the host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    home.file.".config/fcitx5/conf/classicui.conf".text = ''
      Theme=Nord-Dark
    '';
  };
}
