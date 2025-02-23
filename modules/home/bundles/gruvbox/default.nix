{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.bundles.gruvbox; # Config path
in {
  # --- Set options
  options.${namespace}.bundles.gruvbox = {
    enable = mkEnableOption "Enables gruvbox theme for host";
    kde = mkEnableOption "Applies theme for KDE Plasma";
  };

  # --- Set configuration
  config = mkIf cfg.enable {  
    # --- Stylix Theme
    stylix = {
      enable = true;
      
      # Wallpaper and Color
      image = ../../../../assets/Wallpapers/Wallhaven/hao-sect.jpg; # Default wallpaper
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
      
      # Cursor
      cursor = mkIf (!cfg.kde) {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };

      # Icons
      iconTheme = mkIf (!cfg.kde) {
        enable = true;
        package = pkgs.gruvbox-plus-icons;
        dark = "Gruvbox-Plus-Dark";
        light = "Gruvbox-Plus-Dark";
      };
   
      # Fonts
      fonts = {
        monospace = {
          package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
          name = "JetBrainsMono Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
      };
    };

    # --- Apply KDE plasma 6 fix if on kde
    home.packages = mkIf cfg.kde [
      pkgs.bibata-cursors
      pkgs.gruvbox-plus-icons
    ];

    programs.plasma = mkIf cfg.kde {
      enable = true;
      
      workspace = {
        colorScheme = "Gruvboxdarkmedium";
        cursor = {
          size = 16;
          theme = "Bibata-Modern-Classic";
        };
        iconTheme = "Gruvbox-Plus-Dark";
      };

      # Fix
      configFile.kded5rc = {
        "Module-gtkconfig"."autoload" = false;
      };
    };
  };
}
