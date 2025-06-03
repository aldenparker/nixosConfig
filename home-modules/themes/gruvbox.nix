{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.themes.gruvbox; # Config path
in
{
  # --- Set options
  options.${namespace}.themes.gruvbox = {
    enable = mkEnableOption "Enables gruvbox theme";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # --- Stylix Theme
    stylix = {
      enable = true;
      autoEnable = true; # Enables stylix for everything it can

      # Disable for specific programs
      targets = {
        waybar.enable = false; # Waybar has it's own styling
        swaylock.enable = config.${namespace}.desktops.niri.enable; # Only enable when using niri, which uses swaylock
      };

      # Wallpaper and Color
      image = ../../assets/wallpapers/wallhaven/hao-sect.jpg; # Default wallpaper
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
      polarity = "dark";

      # Opacity
      opacity = {
        terminal = 0.85;
      };

      # Cursor
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };

      # Icons
      iconTheme = {
        enable = true;
        package = pkgs.gruvbox-plus-icons;
        dark = "Gruvbox-Plus-Dark";
        light = "Gruvbox-Plus-Dark";
      };

      # Fonts
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono NFM";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sizes = {
          terminal = 11;
        };
      };
    };
  };
}
