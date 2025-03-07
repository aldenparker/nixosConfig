{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.niri; # Config path
in
{
  # TODO: add polkit, bar, screen lock
  # --- Set options
  options.${namespace}.programs.niri = {
    enable = mkEnableOption "Configures niri for host and all other programs needed for desktop environment";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # --- Niri config
    programs.niri.settings = {
      # input.keyboard.xkb.layout = "no";
      input = {
        mouse.accel-speed = 1.0;
        touchpad = {
          tap = true;
          dwt = true;
          natural-scroll = true;
          click-method = "clickfinger";
        };
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "10%";
        };
      };

      # input.tablet.map-to-output = "eDP-1";
      # input.touch.map-to-output = "eDP-1";

      # input.warp-mouse-to-focus = true;

      prefer-no-csd = true;

      layout = {
        gaps = 16;
        struts.left = 64;
        struts.right = 64;
        border.width = 4;
        always-center-single-column = true;

        empty-workspace-above-first = true;

        focus-ring = {
          enable = true;
          width = 5;
          active.color = "#00000055";
        };

        shadow.enable = true;

        tab-indicator = {
          position = "top";
          gaps-between-tabs = 10;
        };

        preset-column-widths = [
          { proportion = 1.0 / 4.0; }
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 1.0; }
        ];

        default-column-width = { };
      };

      hotkey-overlay.skip-at-startup = true;
      # clipboard.disable-primary = true;

      screenshot-path = "~/Pictures/Screenshots/%Y-%m-%dT%H:%M:%S.png";

      # switch-events =
      #   with config.lib.niri.actions;
      #   let
      #     sh = spawn "sh" "-c";
      #   in
      #   {
      #     tablet-mode-on.action = sh "notify-send tablet-mode-on";
      #     tablet-mode-off.action = sh "notify-send tablet-mode-off";
      #     lid-open.action = sh "notify-send lid-open";
      #     lid-close.action = sh "notify-send lid-close";
      #   };

      binds =
        with config.lib.niri.actions;
        let
          sh = spawn "sh" "-c";
        in
        {
          "Mod+T".action = spawn "kitty";
          "Mod+O".action = show-hotkey-overlay;
          "Mod+D".action = spawn "fuzzel";

          "Mod+Shift+S".action = screenshot;
          "Print".action = screenshot-screen;
          "Mod+Print".action = screenshot-window;

          "XF86AudioRaiseVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
          "XF86AudioLowerVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          "XF86AudioMute".action = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

          # TODO: fix brightness control
          "XF86MonBrightnessUp".action = sh "brightnessctl set 10%+";
          "XF86MonBrightnessDown".action = sh "brightnessctl set 10%-";

          "Mod+Q".action = close-window;

          "Mod+Shift+Space".action = toggle-window-floating;

          "Mod+Space".action = toggle-column-tabbed-display;

          "Mod+Right".action = focus-column-right;
          "Mod+Left".action = focus-column-left;

          "Mod+Shift+Right".action = consume-or-expel-window-right;
          "Mod+Shift+Left".action = consume-or-expel-window-left;

          "Mod+Tab".action = focus-window-down-or-column-right;
          "Mod+Shift+Tab".action = focus-window-up-or-column-left;

          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;

          "Mod+R".action = switch-preset-column-width;
          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;
          "Mod+C".action = center-column;

          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Equal".action = set-column-width "+10%";
          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+Equal".action = set-window-height "+10%";

          "Mod+Shift+Escape".action = toggle-keyboard-shortcuts-inhibit;
          "Mod+Shift+E".action = quit;
          "Mod+Shift+P".action = power-off-monitors;

          "Mod+Shift+Ctrl+T".action = toggle-debug-tint;
        };

      window-rules =
        let
          colors = config.lib.stylix.colors.withHashtag;
        in
        [
          {
            # Round Corners of Focus Ring
            draw-border-with-background = false;
            geometry-corner-radius =
              let
                r = 8.0;
              in
              {
                top-left = r;
                top-right = r;
                bottom-left = r;
                bottom-right = r;
              };
            clip-to-geometry = true;
          }
        ];

      spawn-at-startup = [
        # {
        #   command = [
        #     "${only-without-session}"
        #     "${lib.getExe pkgs.waybar}"
        #   ];
        # }
        {
          command = [
            "${lib.getExe pkgs.swaybg}"
            "-m"
            "fill"
            "-i"
            "${config.stylix.image}"
          ];
        }
        {
          command = [
            "${lib.getExe pkgs.xwayland-satellite-unstable}"
            ":0"
          ];
        }
      ];

      # --- Environment variables
      environment = {
        DISPLAY = ":0"; # For XWayland apps
      };
    };
  };
}
