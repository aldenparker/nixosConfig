{ lib, inputs, config, pkgs, namespace, ... }:

with lib;

let
  font-size = "16px";
  cfg = config.${namespace}.programs.waybar; # Config path
in {
  # --- Set options
  options.${namespace}.programs.waybar = {
    enable = mkEnableOption "Enables waybar for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Install nm-applet for wifi
    home.packages = with pkgs; [
      networkmanagerapplet
    ];

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          # General Settings
          "layer" = "top";
          "height" = 40;
          "margin-top" = 14;
          "margin-bottom" = 0;
          "margin-left" = 14;
          "margin-right" = 14;
          "spacing" = 5;

          # Modules Left
          "modules-left" = [
              "custom/appmenuicon"
              "hyprland/window"
              "custom/empty"
          ];

          # Modules Center
          "modules-center" = [
              "hyprland/workspaces"
          ];

          # Modules Right    
          "modules-right" = [
              "custom/updates"
              "pulseaudio"
              "bluetooth"
              "battery"
              "network"
              "group/hardware"
              "group/tools"
              "tray"
              "custom/notification"
              "custom/exit"
              "clock"
          ];

          # --- Modules
          # Workspaces
          "hyprland/workspaces" = {
            "on-scroll-up" = "hyprctl dispatch workspace r-1";
            "on-scroll-down" = "hyprctl dispatch workspace r+1";
            "on-click" = "activate";
            "active-only" = false;
            "all-outputs" = true;
            "format" = "{}";
            "format-icons" = {
              "urgent" = "";
              "active" = "";
              "default" = "";
            };
            "persistent-workspaces" = {
              "*" = 5;
            };
          };

          # Taskbar
          "wlr/taskbar" = {
            "format" = "{icon}";
            "icon-size" = 18;
            "tooltip-format" = "{title}";
            "on-click" = "activate";
            "on-click-middle" = "close";
            "ignore-list" = ["Alacritty" "kitty"];
            "app_ids-mapping" = {
              "firefoxdeveloperedition" = "firefox-developer-edition";
            };
          };

          # Hyprland Window
          "hyprland/window" = {
            "separate-outputs" = true;
          };
          # Empty
          "custom/empty" = {
            "format" = "";
          };

            # Tools
          "custom/tools" = {
            "format" = "󱁤";
            "tooltip-format" = "Tools";
          };

          # Wallpaper
          "custom/wallpaper" = {
            "format" = "";
            "on-click" = "bash -c waypaper &";
            "tooltip-format" = "Select a wallpaper";
          };

          # Calculator
          "custom/calculator" = {
            "format" = "";
            "on-click" = "qalculate-gtk";
            "tooltip-format" = "Open calculator";
          };

          # Rofi Application Launcher
          "custom/appmenu" = {
            # START APPS LABEL
            "format" = "Apps";
            # END APPS LABEL
            "on-click" = "sleep 0.2;wofi --show drun";
            "tooltip-format" = "Open the application launcher";
          };

          # Rofi Application Launcher
          "custom/appmenuicon" = {
            "format" = "󱄅";
            "on-click" = "sleep 0.2;wofi --show drun";
            "tooltip-format" = "Open the application launcher";
          };

          # Power Menu
          "custom/exit" = {
            "format" = "";
            "on-click" = "sudo shutdown";
            "on-click-right" = "hyprctl dispatch exit";
            "tooltip-format" = "Left: Shutdown\nRight: Logout";
          };

          # SwayNC
          "custom/notification" = {
            "tooltip-format" = "Left: Notifications\nRight: Do not disturb";
            "format" = "{icon}";
            "format-icons" = {
              "notification" = "<span foreground='red'><sup></sup></span>";
              "none" = "";
              "dnd-notification" = "<span foreground='red'><sup></sup></span>";
              "dnd-none" = "";
              "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
              "inhibited-none" = "";
              "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
              "dnd-inhibited-none" = "";
            };
            "return-type" = "json";
            "exec-if" = "which swaync-client";
            "exec" = "swaync-client -swb";
            "on-click" = "swaync-client -t -sw";
            "on-click-right" = "swaync-client -d -sw";
            "escape" = true;
          };

          # Keyboard State
          "keyboard-state" = {
            "numlock" = true;
            "capslock" = true;
            "format" = "{name} {icon}";
            "format-icons" = {
              "locked" = "";
              "unlocked" = "";
            };
          };

          # System tray
          "tray" = {
            "icon-size" = 12;
            "spacing" = 5;
          };

          # Clock
          "clock" = {
            "format" = "{:%H:%M %a}";
            "on-click" = "flatpak run com.ml4w.calendar";
            "timezone" = "";
            "tooltip" = false;
          };

          # System
          "custom/system" = {
            "format" = "󰻠";
            "tooltip" = false;
          };

          # CPU
          "cpu" = {
            "format" = "/ C {usage}% ";
            "on-click" = "~/.config/ml4w/settings/system-monitor.sh";
          };

          # Memory
          "memory" = {
            "format" = "/ M {}% ";
            "on-click" = "~/.config/ml4w/settings/system-monitor.sh";
          };

          # Harddisc space used
          "disk" = {
            "interval" = 30;
            "format" = "D {percentage_used}% ";
            "path" = "/";
            "on-click" = "~/.config/ml4w/settings/system-monitor.sh";
          };

          "hyprland/language" = {
            "format" = "/ K {short}";
          };

          # Group Hardware
          "group/hardware" = {
            "orientation" = "inherit";
            "drawer" = {
              "transition-duration" = 300;
              "children-class" = "not-memory";
              "transition-left-to-right" = false;
            };
            "modules" = ["custom/system" "disk" "cpu" "memory" "hyprland/language"];
          };

          # Group Tools
          "group/tools" = {
            "orientation" = "inherit";
            "drawer" = {
              "transition-duration" = 300;
              "children-class" = "not-memory";
              "transition-left-to-right" = false;
            };
            "modules" = [
              "custom/tools"
              "custom/cliphist"
              "custom/hypridle"
              "custom/hyprshade"
            ];
          };

          # Group Settings
          "group/settings" = {
            "orientation" = "inherit";
            "drawer" = {
              "transition-duration" = 300;
              "children-class" = "not-memory";
              "transition-left-to-right" = true;
            };
            "modules" = [
              "custom/settings"
              "custom/waybarthemes"
              "custom/wallpaper"
            ];
          };

          # Network
          "network" = {
            "format" = "{ifname}";
            "format-wifi" = " {essid} ({signalStrength}%)";
            "format-ethernet" = "󰈀  {ifname}";
            "format-disconnected" = "Disconnected ⚠";
            "tooltip-format" = "󰈀 {ifname} via {gwaddri}";
            "tooltip-format-wifi" = "  {ifname} @ {essid}\nIP: {ipaddr}\nStrength: {signalStrength}%\nFreq: {frequency}MHz\nUp: {bandwidthUpBits} Down: {bandwidthDownBits}";
            "tooltip-format-ethernet" = "󰈀 {ifname}\nIP: {ipaddr}\n up: {bandwidthUpBits} down: {bandwidthDownBits}";
            "tooltip-format-disconnected" = "Disconnected";
            "max-length" = 50;
            "on-click" = "~/.config/ml4w/settings/networkmanager.sh";
            "on-click-right" = "~/.config/ml4w/scripts/nm-applet.sh toggle";
          };

          # Battery
          "battery" = {
            "states" = {
              # "good" = 95;
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{icon} {capacity}%";
            "format-charging" = "  {capacity}%";
            "format-plugged" = "  {capacity}%";
            "format-alt" = "{icon}  {time}";
            # "format-good" = ""; # An empty format will hide the module
            # "format-full" = "";
            "format-icons" = [" " " " " " " " " "];
          };

          # Pulseaudio
          "pulseaudio" = {
            # "scroll-step" = 1; # % can be a float
            "format" = "{icon}  {volume}%";
            "format-bluetooth" = "{volume}% {icon} {format_source}";
            "format-bluetooth-muted" = " {icon} {format_source}";
            "format-muted" = " {format_source}";
            "format-source" = "{volume}% ";
            "format-source-muted" = "";
            "format-icons" = {
              "headphone" = " ";
              "hands-free" = " ";
              "headset" = " ";
              "phone" = " ";
              "portable" = " ";
              "car" = " ";
              "default" = ["" "" ""];
            };
            "on-click" = "pavucontrol";
          };

          # Bluetooth
          "bluetooth" = {
            "format" = " {status}";
            "format-disabled" = "";
            "format-off" = "";
            "interval" = 30;
            "on-click" = "blueman-manager";
            "format-no-controller" = "";
          };

          # Other
          "user" = {
            "format" = "{user}";
            "interval" = 60;
            "icon" = false;
          };

          # backlight:
          "backlight" = {
            "format" = "{icon} {percent}%";
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
            "scroll-step" = 1;
          };
        };
      };
      style = ''
        * {
          font-family: "JetBrainsMono Nerd Font";
          border: none;
          border-radius: 0px;
        }

        window#waybar {
          background-color: rgba(0,0,0,0.8);
          border-bottom: 0px solid #ffffff;
          /* color: #FFFFFF; */
          background: transparent;
          transition-property: background-color;
          transition-duration: .5s;
        }

        /* -----------------------------------------------------
        * Workspaces
        * ----------------------------------------------------- */

        #workspaces {
            background: @base00;
            margin: 3px 0px 3px 0px;
            padding: 0px 1px;
            border-radius: 15px;
            border: 0px;
            font-weight: bold;
            font-style: normal;
            opacity: 0.8;
            font-size: ${font-size};
            color: @base05;
        }

        #workspaces button {
            padding: 0px 5px;
            margin: 4px 3px;
            border-radius: 15px;
            border: 0px;
            color: @base05;
            background-color: @base02;
            transition: all 0.3s ease-in-out;
            opacity: 0.4;
        }

        #workspaces button.active {
            color: @base05;
            background: @base02;
            border-radius: 15px;
            min-width: 40px;
            transition: all 0.3s ease-in-out;
            opacity: 1.0;
        }

        #workspaces button:hover {
            color: @base05;
            background: @base02;
            border-radius: 15px;
            opacity: 0.7;
        }

        /* -----------------------------------------------------
        * Tooltips
        * ----------------------------------------------------- */

        tooltip {
            border-radius: 16px;
            background-color: @base00;
            opacity: 0.9;
            padding: 20px;
            margin: 0px;
        }

        tooltip label {
            color: @base04;
        }

        /* -----------------------------------------------------
        * Window
        * ----------------------------------------------------- */

        #window {
            background: @base00;
            margin: 3px 0px 3px 0px;
            padding: 2px 10px 0px 10px;
            border-radius: 12px;
            color: @base04;
            font-size: ${font-size};
            font-weight: normal;
            opacity: 0.8;
        }

        window#waybar.empty #window {
          background-color: transparent;
        }

        /* -----------------------------------------------------
        * Taskbar
        * ----------------------------------------------------- */

        #taskbar {
          background: @base00;
          margin: 3px 0px 3px 0px;
          padding: 0px;
          border-radius: 15px;
          font-weight: normal;
          font-style: normal;
          opacity: 0.8;
          border: 3px solid @base00;
        }

        #taskbar button {
          margin:0;
          border-radius: 15px;
          padding: 0px 5px 0px 5px;
        }

        #taskbar.empty {
          background:transparent;
          border:0;
          padding:0;
          margin:0;
        }

        /* -----------------------------------------------------
        * Modules
        * ----------------------------------------------------- */

        .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
        }

        .modules-right > widget:last-child > #workspaces {
            margin-right: 0;
        }

        /* -----------------------------------------------------
        * Idle Inhibator
        * ----------------------------------------------------- */

        #idle_inhibitor {
            font-size: ${font-size};
            font-weight: bold;
            opacity: 0.8;
            color: @base05;
        }

        #idle_inhibitor.activated {
            font-size: ${font-size};
            font-weight: bold;
            opacity: 0.8;
            color: #dc2f2f;
        }

        /* -----------------------------------------------------
        * Custom Modules
        * ----------------------------------------------------- */

        #custom-appmenu {
            background-color: @base00;
            font-size: ${font-size};
            color: @base05;
            border-radius: 15px;
            padding: 0px 10px 0px 10px;
            margin: 3px 0px 3px 0px;
            opacity: 0.8;
            border: 3px solid @base02;
        }

        #custom-appmenuicon {
          background-color: @base00;
          font-size: ${font-size};
          color: @base05;
          border-radius: 15px;
          padding: 0px 14px 0px 10px;
          margin: 3px 0px 3px 0px;
          opacity: 0.8;
          border: 3px solid @base02;
        }

        /* -----------------------------------------------------
        * Custom Notification
        * ----------------------------------------------------- */

        #custom-notification {
            margin: 3px 0px 3px 0px;
            padding: 0px 8px 0px 8px;
            font-size: ${font-size};
            color: @base05;
            opacity: 0.8;
            border-radius: 15px;
            background-color: @base00;
        }

        /* -----------------------------------------------------
        * Custom Exit
        * ----------------------------------------------------- */

        #custom-exit {
            margin: 3px 0px 3px 0px;
            padding: 0px 8px 0px 8px;
            border-radius: 15px;
            font-size: ${font-size};
            color: @base05;
            opacity: 0.8;
            background-color: @base00;
        }

        /* -----------------------------------------------------
        * Hardware Group
        * ----------------------------------------------------- */

        #disk,#memory,#cpu,#language {
            margin: 0px;
            padding: 0px;
            font-size: ${font-size};
            color: @base05;
        }

        #language {
            margin-right: 10px;
        }

        /* -----------------------------------------------------
        * Clock
        * ----------------------------------------------------- */

        #clock {
            background-color: @base00;
            font-size: ${font-size};
            color: @base05;
            border-radius: 15px;
            padding: 1px 10px 0px 10px;
            margin: 3px 0px 3px 0px;
            opacity:0.8;
            border:3px solid @base02;
        }

        /* -----------------------------------------------------
        * Backlight
        * ----------------------------------------------------- */

        #backlight {
            background-color: @base00;
            font-size: ${font-size};
            color: @base04;
            border-radius: 15px;
            padding: 2px 10px 0px 10px;
            margin: 3px 0px 3px 0px;
            opacity:0.8;
        }

        /* -----------------------------------------------------
        * Pulseaudio
        * ----------------------------------------------------- */

        #pulseaudio {
            background-color: @base00;
            font-size: ${font-size};
            color: @base04;
            border-radius: 15px;
            padding: 2px 10px 0px 10px;
            margin: 3px 0px 3px 0px;
            opacity:0.8;
        }

        #pulseaudio.muted {
            background-color: @base00;
            color: @base05;
        }

        /* -----------------------------------------------------
        * Network
        * ----------------------------------------------------- */

        #network {
            background-color: @base00;
            font-size: ${font-size};
            color: @base04;
            border-radius: 15px;
            padding: 2px 10px 0px 10px;
            margin: 3px 0px 3px 0px;
            opacity:0.8;
        }

        #network.ethernet {
            background-color: @base00;
            color: @base04;
        }

        #network.wifi {
            background-color: @base00;
            color: @base04;
        }

        /* -----------------------------------------------------
        * Bluetooth
        * ----------------------------------------------------- */

        #bluetooth, #bluetooth.on, #bluetooth.connected {
            background-color: @base00;
            font-size: ${font-size};
            color: @base04;
            border-radius: 15px;
            padding: 2px 10px 0px 10px;
            margin: 3px 0px 3px 0px;
            opacity:0.8;
        }

        #bluetooth.off {
            background-color: transparent;
            padding: 0px;
            margin: 0px;
        }

        /* -----------------------------------------------------
        * Battery
        * ----------------------------------------------------- */

        #battery {
            background-color: @base00;
            font-size: ${font-size};
            color: @base04;
            border-radius: 15px;
            padding: 2px 15px 0px 10px;
            margin: 3px 0px 3px 0px;
            opacity: 0.8;
        }

        #battery.charging, #battery.plugged {
            color: @base04;
            background-color: @base00;
        }

        @keyframes blink {
          to {
            background-color: @base00;
            color: @base04;
          }
        }

        #battery.critical:not(.charging) {
            background-color: #f53c3c;
            color: @base04;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        /* -----------------------------------------------------
        * Tray
        * ----------------------------------------------------- */

        #tray {
            margin: 3px 0px 3px 0px;
            background-color: @base00;
            color: @base04;
            border-radius: 15px;
            opacity: 0.8;
            padding: 0px 8px 0px 8px;
        }

        #tray > .passive {
            -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
            -gtk-icon-effect: highlight;
        }
      '';
    };
  };
}
