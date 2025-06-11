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
          "Mod+Alt+Tab".action = sh "kitten quick-access-terminal"; # Spawn quick acess terminal

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
          # "Mod+Ctrl+Up".action = toggle-overview; TODO: make available on update

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
          "Mod+Shift+E".action = sh "wlogout -p layer-shell -b 4"; # Bring up power menu
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
            "swaync"
          ];
        }
        {
          command = [
            "waybar"
          ];
        }
        {
          command = [
            "fcitx5"
            "-d"
          ];
        }
        {
          command = [
            "blueman-applet"
          ];
        }
        {
          command = [
            "swww-daemon"
          ];
        }
        {
          command = [
            "xwayland-satellite"
            ":0"
          ];
        }
        {
          command = [
            "swayosd-server"
          ];
        }
        {
          command = [
            "kanshi"
          ];
        }
      ];

      # --- Environment variables
      environment = {
        DISPLAY = ":0"; # For XWayland apps

        # For input handler
        XMODIFIERS = "@im=fcitx";
        QT_IM_MODULE = "fcitx";
      };
    };

    # --- Swaylock config (Stylix takes care of coloring)
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        ignore-empty-password = true;
        show-failed-attempts = true;

        clock = true;
        timestr = "%R";
        datestr = "%a, %e of %B";

        screenshots = true;
        effect-blur = "10x2";

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
    home.file.".config/waybar" = {
      source = ./waybar-config;
      recursive = true;
    };

    # --- Swaync config
    services.swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "top";
        layer-shell = true;
        cssPriority = "application";
        control-center-margin-top = 10;
        control-center-margin-bottom = 10;
        control-center-margin-right = 10;
        control-center-margin-left = 0;
        notification-2fa-action = true;
        notification-inline-replies = false;
        notification-icon-size = 64;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
      };
    };

    # --- Enable fuzzel so that stylix can theme it
    programs.fuzzel.enable = true;

    # --- Config logout screen
    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "swaylock";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "logout";
          action = "niri msg action Quit { skip_confirmation: true }";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];
      style =
        with config.lib.stylix.colors.withHashtag;
        let
          iconThemePackage = config.stylix.iconTheme.package;
          iconThemeName = config.stylix.iconTheme.${config.stylix.polarity};
          iconThemePath = "${iconThemePackage}/share/icons/${iconThemeName}";
        in
        ''
          @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
          @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};

          @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
          @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};

          * {
            font-family: "${config.stylix.fonts.monospace.name}";
            font-size: ${builtins.toString config.stylix.fonts.sizes.desktop}pt;
            background-image: none;
          }

          window {
            background-color: alpha(@base00, 0.5);
          }

          button {
            color: @base05;
            font-size: 16px;
            background-color: @base01;
            border-style: none;
            background-repeat: no-repeat;
            background-position: center;
            background-size: 35%;
            border-radius:30px;
            margin: 182px 5px;
            text-shadow: 0px 0px;
            box-shadow: 0px 0px;
          }

          button:focus, button:active, button:hover {
            background-color: @base02;
            outline-style: none;
          }

          #lock {
            background-image: url("${iconThemePath}/status/48/status_lock.svg"), url("${pkgs.wlogout}/share/wlogout/icons/lock.png");
          }

          #logout {
            background-image: url("${iconThemePath}/status/48/stock_dialog-warning.svg"), url("${pkgs.wlogout}/share/wlogout/icons/logout.png");
          }

          #suspend {
            background-image: url("${iconThemePath}/status/48/state_paused.svg"), url("${pkgs.wlogout}/share/wlogout/icons/suspend.png");
          }

          #hibernate {
            background-image: url("${iconThemePath}/status/48/weather-clear-night.svg"), url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png");
          }

          #shutdown {
            background-image: url("${iconThemePath}/status/48/state_shutoff.svg"), url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png");
          }

          #reboot {
            background-image: url("${iconThemePath}/status/48/state_running.svg"), url("${pkgs.wlogout}/share/wlogout/icons/reboot.png");
          }
        '';
    };
  };
}
