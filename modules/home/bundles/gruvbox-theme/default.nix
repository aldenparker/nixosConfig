{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.bundles.gruvbox-gtk-theme; # Config path
in {
  # --- Set options
  options.${namespace}.bundles.gruvbox-gtk-theme = {
    enable = mkEnableOption "Configures gtk theme for grubox icons and colors";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    gtk = {
      enable = true;

      theme = {
        package = mkForce pkgs.gruvbox-gtk-theme;
        name = mkForce "Gruvbox-Dark";
      };

      iconTheme = {
        package = mkForce pkgs.gruvbox-gtk-theme;
        name = mkForce "Gruvbox-Dark";
      };
    };
  };
}
