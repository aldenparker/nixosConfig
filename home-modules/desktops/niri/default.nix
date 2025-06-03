{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.desktops.niri; # Config path
in
{
  # --- Set options
  options.${namespace}.desktops.niri = {
    enable = mkEnableOption "Configures niri and all other packages used for desktop features";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # --- Niri config
    programs.niri.settings = {
      input = {
        mouse.accel-speed = 1.0;

        touchpad = {
          tap = true;
          natural-scroll = true;
          click-method = "clickfinger";
        };

        touch = {
          map-to-output = "eDP-1";
        };

        tablet = {
          map-to-output = "HDMI-A-1";
        };

        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "50%";
        };

        warp-mouse-to-focus = true;
      };

      prefer-no-csd = true;

      layout = {
        gaps = 16;
        struts.left = 16;
        struts.right = 16;
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

        default-column-width = {
          proportion = 1.0;
        };
      };

      hotkey-overlay.skip-at-startup = true;

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
          # Direct Spawns
          "Mod+T".action = spawn "kitty";
          "Mod+O".action = show-hotkey-overlay;
          "Mod+D".action = spawn "fuzzel";
          "Mod+Alt+Tab".action = sh ''
            pid=$(ps aux | grep "kitty +kitten.*quick-access" | grep -v grep | awk '{print $2}')
            if [ -z "$pid" ]
            then
              kitten quick-access-terminal &
            else
              kill $pid
            fi
          ''; # Script to fix quick access terminal not closing when hotkey used

          # Screenshot Binds
          "Mod+Shift+S".action = screenshot;
          # "Print".action = screenshot-screen; TODO: Switch back to this after it is fixed
          "Print".action = sh "niri msg action screenshot-screen";
          "Mod+Print".action = screenshot-window;

          # Volume
          "XF86AudioRaiseVolume".action = sh "swayosd-client --output-volume 10 --max-volume 100";
          "XF86AudioLowerVolume".action = sh "swayosd-client --output-volume -10 --max-volume 100";
          "XF86AudioMute".action = sh "swayosd-client --output-volume mute-toggle";

          # TODO: fix brightness control so it runs for all monitors
          "XF86MonBrightnessUp".action = sh "swayosd-client --brightness +10; asus-wmi-screenpad-ctl -a 10";
          "XF86MonBrightnessDown".action =
            sh "swayosd-client --brightness -10; asus-wmi-screenpad-ctl -a -10";

          # Lock and Screensaver
          "Mod+L".action = sh "swaylock";

          # Window Manupulation
          "Mod+Q".action = close-window;
          "Mod+Shift+Space".action = toggle-window-floating;
          "Mod+Space".action = toggle-column-tabbed-display;

          # Focus Binds
          "Mod+Right".action = focus-column-right;
          "Mod+Left".action = focus-column-left;
          "Mod+Up".action = focus-workspace-up;
          "Mod+Down".action = focus-workspace-down;
          "Mod+Tab".action = focus-window-down-or-column-right;
          "Mod+Shift+Tab".action = focus-window-up-or-column-left;

          # Special Window Move Binds
          "Mod+Shift+Right".action = consume-or-expel-window-right;
          "Mod+Shift+Left".action = consume-or-expel-window-left;
          "Mod+Shift+Up".action = move-window-to-workspace-up;
          "Mod+Shift+Down".action = move-window-to-workspace-down;

          # Normal Move Binds
          "Mod+Alt+Right".action = move-column-right;
          "Mod+Alt+Left".action = move-column-left;
          "Mod+Alt+Up".action = move-window-up;
          "Mod+Alt+Down".action = move-window-down;

          # Window Sizing Binds
          "Mod+R".action = switch-preset-column-width;
          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;
          "Mod+C".action = center-column;
          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Equal".action = set-column-width "+10%";
          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+Equal".action = set-window-height "+10%";

          # Misc
          "Mod+Shift+Escape".action = toggle-keyboard-shortcuts-inhibit;
          "Mod+Shift+E".action = quit;
          "Mod+Shift+P".action = power-off-monitors;
        };

      # Pass cursor config from stylix
      cursor = {
        theme = config.stylix.cursor.name;
        size = config.stylix.cursor.size;
      };

      # Window rules
      window-rules = [
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
        {
          command = [
            "${lib.getExe pkgs.mako}"
          ];
        }
        {
          command = [
            "${lib.getExe pkgs.waybar}"
          ];
        }
        {
          command = [
            "${lib.getExe pkgs.fcitx5}"
          ];
        }
        {
          command = [
            "${pkgs.blueman}/bin/blueman-applet"
          ];
        }
        {
          command = [
            "${pkgs.swww}/bin/swww-daemon"
          ];
        }
        {
          command = [
            "${lib.getExe pkgs.xwayland-satellite-unstable}"
            ":0"
          ];
        }
        {
          command = [
            "${pkgs.swayosd}/bin/swayosd-server"
          ];
        }
        {
          command = [
            "${pkgs.kanshi}/bin/kanshi"
          ];
        }
      ];

      # --- Environment variables
      environment = {
        DISPLAY = ":0"; # For XWayland apps
      };
    };

    # --- Swaylock config (Stylix takes care of coloring)
    programs.swaylock = {
      enable = true;
      settings = {
        ignore-empty-password = true;
        show-failed-attempts = true;

        clock = true;
        timestr = "%R";
        datestr = "%a, %e of %B";

        screenshots = true;
        effect-blur = 10 x2;

        indicator-radius = 80;
        indicator-thickness = 10;

        line-uses-ring = true;
      };
    };

    # --- Portals config
    home.file.".config/xdg-desktop-portal/portals.conf" = {
      source = ./portals.conf;
    };

    # --- Waybar Config
    programs.waybar = {
      enable = true;
      style = ./waybar-style.css;
      settings = {
        layer = "bottom";
        position = "bottom";
        mod = "dock";
        exclusive = true;
        gtk-layer-shell = true;
        margin-bottom = -1;
        passthrough = false;
        height = 41;

        modules-left = [
          "niri/workspaces"
        ];
        modules-center = [
          "niri/window"
        ];
        modules-right = [
          "cpu"
          "memory"
          "disk"
          "tray"
          "pulseaudio"
          "battery"
          "clock"
        ];

        "niri/workspaces" = {
          icon-size = 32;
          spacing = 16;
        };
        "cpu" = {
          interval = 5;
          format = "  {usage}%";
          max-length = 10;
        };
        "disk" = {
          interval = 30;
          format = "󰋊 {percentage_used}%";
          path = "/";
          tooltip = true;
          unit = "GB";
          tooltip-format = "Available {free} of {total}";
        };
        "memory" = {
          interval = 10;
          format = "  {percentage}%";
          max-length = 10;
          tooltip = true;
          tooltip-format = "RAM - {used:0.1f}GiB used";
        };
        "niri/window" = {
          format = "{app_id} | {title:.80}";
          separate-outputs = true;
          icon = true;
          rewrite = {
            "dev.zed.Zed [|] (.*)" = "zed | $1";
          };
        };
        "wlr/taskbar" = {
          format = "{icon} {title:.17}";
          icon-size = 28;
          spacing = 3;
          on-click-middle = "close";
          tooltip-format = "{title}";
          ignore-list = [ ];
          on-click = "activate";
        };
        "tray" = {
          icon-size = 18;
          spacing = 3;
        };
        "clock" = {
          format = "{:%r\n %m.%d.%Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          timezone = "America/Los_Angeles";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
        "pulseaudio" = {
          max-volume = 100;
          scroll-step = 10;
          format = "{icon}";
          tooltip-format = "{volume}%";
          format-muted = " ";
          format-icons = {
            default = [
              " "
              " "
              " "
            ];
          };
          on-click = "pavucontrol";
        };
      };
    };

    # --- Mako config
    services.mako = {
      enable = true;
      settings = {
        # NO COLOR CONFIG... Left to stylix
        on-button-left = "invoke-default-action";
        on-button-right = "dismiss-group";
        on-touch = "dismiss";
        on-notify = "none";

        layer = "top";
        anchor = "top-right";
        outer-margin = 0;
        margin = 10;
        padding = 5;
        text-alignment = "left";

        border-size = 4;
        border-radius = 0;

        icons = 1;
        max-history = 5;
        max-icon-size = 100;

        markup = 1;
        actions = 1;
        history = 1;
        default-timeout = 5000;
        ignore-timeout = 0;
        group-by = "none";
        max-visible = 5;
        output = "";

        icon-path = "";
        icon-location = "left";
      };
    };
  };
}
