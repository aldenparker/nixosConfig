{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.kitty; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.kitty = {
    enable = mkEnableOption "Enables kitty terminal for the host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      themeFile = "GruvboxMaterialDarkMedium";
      settings = {
        font_family = "JetBrainsMono Nerd Font";
        font_size = 11;
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        remember_window_size = "no";
        initial_window_width = 950;
        initial_window_height = 500;
        cursor_blink_interval = 0.5;
        cursor_stop_blinking_after = 1;
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        enable_audio_bell = "no";
        window_padding_width = 0;
        background_opacity = mkForce 0.85;
        dynamic_background_opacity = "yes";
        confirm_os_window_close = 0;
        selection_foreground = "none";
        selection_background = "none";
        cursor_trail = 1;
        cursor_trail_decay = "0.1 0.4";
        cursor_trail_start_threshold = 0;
      };
    };
  };
}
