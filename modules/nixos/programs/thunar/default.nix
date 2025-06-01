{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.thunar; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.thunar = {
    enable = mkEnableOption "Enables thunar for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    environment.systemPackages = with pkgs; [
      gnome-disk-utility
    ];

    programs.xfconf.enable = true;
    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images
  };
}
