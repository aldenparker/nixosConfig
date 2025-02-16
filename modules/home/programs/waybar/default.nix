,{ lib, inputs, config, pkgs, namespace, ... }:

with lib;

let
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
          "margin-top" = 14;
          "margin-bottom" = 0;
          "margin-left" = 14;
          "margin-right" = 14;    
          "spacing" = 0;

          # Modules Left
          "modules-left" = [
              "custom/appmenu"
              "group/links"
              #"wlr/taskbar"
              "group/quicklinks"
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
              #"backlight"
              "bluetooth"
              "battery"
              "network"
              "group/hardware"
              "group/tools"
              "tray"
              "custom/notification"
              "custom/exit"
              "custom/ml4w-welcome"
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
            "rewrite" = {
              "Firefox Web Browser" = "Firefox";
              "Foot Server" = "Terminal";
            };
          };

          # Hyprland Window
          "hyprland/window" = {
            "rewrite" = {
              "(.*) - Brave" = "$1";
              "(.*) - Chromium" = "$1";
              "(.*) - Brave Search" = "$1";
              "(.*) - Outlook" = "$1";
              "(.*) Microsoft Teams" = "$1"
            };
            "separate-outputs" = true;
          };

          # ML4W Welcome App
          "custom/ml4w-welcome" = {
            "on-click" = "flatpak run com.ml4w.sidebar";
            "format" = " ";
            "tooltip-format" = "Open ML4W Sidebar App";
          };

          # Empty
          "custom/empty" = {
            "format" = "";
          };

            # Tools
          "custom/tools" = {
            "format" = "";
            "tooltip-format" = "Tools";
          };

          # Cliphist
          "custom/cliphist" = {
            "format" = "";
            "on-click" = "sleep 0.1 && ~/.config/ml4w/scripts/cliphist.sh";
            "on-click-right" = "sleep 0.1 && ~/.config/ml4w/scripts/cliphist.sh d";
            "on-click-middle" = "sleep 0.1 && ~/.config/ml4w/scripts/cliphist.sh w";
            "tooltip-format" = "Left: Open clipboard Manager\nRight: Delete an entry\nMiddle: Clear list";
          };

          # Updates Count
          "custom/updates" = {
            "format" = "  {}";
            "escape" = true;
            "return-type" = "json";
            "exec" = "~/.config/ml4w/scripts/updates.sh";
            "interval" = 1800;
            "on-click" = "$(cat ~/.config/ml4w/settings/terminal.sh) --class dotfiles-floating -e ~/.config/ml4w/scripts/installupdates.sh";
            "on-click-right" = "~/.config/ml4w/settings/software.sh";
          };

          # Wallpaper
          "custom/wallpaper" = {
            "format" = "";
            "on-click" = "bash -c waypaper &";
            "on-click-right" = "~/.config/hypr/scripts/wallpaper-effects.sh";
            "tooltip-format" = "Left: Select a wallpaper\nRight: Select wallpaper effect";
          };

          # Waybar Themes
          "custom/waybarthemes" = {
            "format" = "";
            "on-click" = "~/.config/waybar/themeswitcher.sh";
            "tooltip-format" = "Select a waybar theme";
          };

          # Settings
          "custom/settings" = {
            "format" = "";
            "on-click" = "sleep 0.1 && com.ml4w.dotfilessettings";
            "tooltip-format" = "ML4W Dotfiles Settings";
          };

          # Keybindings
          "custom/keybindings" = {
            "format" = "";
            "on-click" = "~/.config/hypr/scripts/keybindings.sh";
            "tooltip" = false;
          };

          # ChatGPT Launcher
          "custom/chatgpt" = {
            "format" = " ";
            "on-click" = "~/.config/ml4w/settings/ai.sh";
            "tooltip-format" = "AI Support";
          };

          # Calculator
          "custom/calculator" = {
            "format" = "";
            "on-click" = "qalculate-gtk";
            "tooltip-format" = "Open calculator";
          };

          # Windows VM
          "custom/windowsvm" = {
            "format" = "";
            "on-click" = "~/.config/ml4w/scripts/launchvm.sh";
            "tooltip" = false;
          };

          # Rofi Application Launcher
          "custom/appmenu" = {
            # START APPS LABEL
            "format" = "Apps";
            # END APPS LABEL
            "on-click" = "sleep 0.2;pkill rofi || rofi -show drun -replace";
            "on-click-right" = "~/.config/hypr/scripts/keybindings.sh";
            "tooltip-format" = "Left: Open the application launcher\nRight: Show all keybindings";
          };

          # Rofi Application Launcher
          "custom/appmenuicon" = {
            "format" = "";
            "on-click" = "sleep 0.2;rofi -show drun -replace";
            "on-click-right" = "~/.config/hypr/scripts/keybindings.sh";
            "tooltip-format" = "Left: Open the application launcher\nRight: Show all keybindings";
          };

          # Power Menu
          "custom/exit" = {
            "format" = "";
            "on-click" = "~/.config/ml4w/scripts/wlogout.sh";
            "on-click-right" = "hyprlock";
            "tooltip-format" = "Left: Power menu\nRight: Lock screen";
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

          # Hyprshade
          "custom/hyprshade" = {
            "format" = "";
            "tooltip-format" = "Toggle Screen Shader";
            "on-click" = "sleep 0.5; ~/.config/hypr/scripts/hyprshade.sh";
            "on-click-right" = "sleep 0.5; ~/.config/hypr/scripts/hyprshade.sh rofi";
          };

          # Hypridle inhibitor
          "custom/hypridle" = {
            "format" = "";
            "return-type" = "json";
            "escape" = true;
            "exec-on-event" = true;
            "interval" = 60;
            "exec" = "~/.config/hypr/scripts/hypridle.sh status";
            "on-click" = "~/.config/hypr/scripts/hypridle.sh toggle";
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
            "icon-size" = 21;
            "spacing" = 10;
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
            "format" = "";
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
            ]
          };

          # Group Links
          "group/links" = {
            "orientation" = "horizontal";
            "modules" = [
              "custom/chatgpt"
              "custom/empty"
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
            ]
          };

          # Network
          "network" = {
            "format" = "{ifname}";
            "format-wifi" = " {essid} ({signalStrength}%)";
            "format-ethernet" = "  {ifname}";
            "format-disconnected" = "Disconnected ⚠";
            "tooltip-format" = " {ifname} via {gwaddri}";
            "tooltip-format-wifi" = "  {ifname} @ {essid}\nIP: {ipaddr}\nStrength: {signalStrength}%\nFreq: {frequency}MHz\nUp: {bandwidthUpBits} Down: {bandwidthDownBits}";
            "tooltip-format-ethernet" = " {ifname}\nIP: {ipaddr}\n up: {bandwidthUpBits} down: {bandwidthDownBits}";
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
          font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
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
            margin: 2px 1px 3px 1px;
            padding: 0px 1px;
            border-radius: 15px;
            border: 0px;
            font-weight: bold;
            font-style: normal;
            opacity: 0.8;
            font-size: 16px;
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
            opacity:1.0;
        }

        #workspaces button:hover {
            color: @base05;
            background: @base02;
            border-radius: 15px;
            opacity:0.7;
        }

        /* -----------------------------------------------------
        * Tooltips
        * ----------------------------------------------------- */

        tooltip {
            border-radius: 16px;
            background-color: @base00;
            opacity:0.9;
            padding:20px;
            margin:0px;
        }

        tooltip label {
            color: @base04;
        }

        /* -----------------------------------------------------
        * Window
        * ----------------------------------------------------- */

        #window {
            background: @base00;
            margin: 5px 15px 5px 0px;
            padding: 2px 10px 0px 10px;
            border-radius: 12px;
            color:@base04;
            font-size:16px;
            font-weight:normal;
            opacity:0.8;
        }

        window#waybar.empty #window {
            background-color:transparent;
        }

        /* -----------------------------------------------------
        * Taskbar
        * ----------------------------------------------------- */

        #taskbar {
            background: @base00;
            margin: 3px 15px 3px 0px;
            padding:0px;
            border-radius: 15px;
            font-weight: normal;
            font-style: normal;
            opacity:0.8;
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
        * Custom Quicklinks
        * ----------------------------------------------------- */

        #custom-brave,
        #custom-browser,
        #custom-keybindings,
        #custom-outlook,
        #custom-filemanager,
        #custom-teams,
        #custom-chatgpt,
        #custom-calculator,
        #custom-windowsvm,
        #custom-cliphist,
        #custom-settings,
        #custom-wallpaper,
        #custom-system,
        #custom-hyprshade,
        #custom-hypridle,
        #custom-tools,
        #custom-quicklink_chromium,
        #custom-quicklink_edge,
        #custom-quicklink_firefox,
        #custom-quicklink_browser,
        #custom-quicklink_filemanager,
        #custom-quicklink_email,
        #custom-quicklink_thunderbird,
        #custom-quicklink_calculator,
        #custom-quicklink1,
        #custom-quicklink2,
        #custom-quicklink3,
        #custom-quicklink4,
        #custom-quicklink5,
        #custom-quicklink6,
        #custom-quicklink7,
        #custom-quicklink8,
        #custom-quicklink9,
        #custom-quicklink10,
        #custom-waybarthemes {
            margin-right: 16px;
            font-size: 20px;
            font-weight: bold;
            opacity: 0.8;
            color: @base05;
        }

        #custom-quicklink_chromium,
        #custom-quicklink_edge,
        #custom-quicklink_firefox,
        #custom-quicklink_browser,
        #custom-quicklink_filemanager,
        #custom-quicklink_email,
        #custom-quicklink_thunderbird,
        #custom-quicklink_calculator,
        #custom-quicklink1,
        #custom-quicklink2,
        #custom-quicklink3,
        #custom-quicklink4,
        #custom-quicklink5,
        #custom-quicklink6,
        #custom-quicklink7,
        #custom-quicklink8,
        #custom-quicklink9,
        #custom-quicklink10 {
            margin-right: 18px;
        }

        #custom-tools {
            margin-right:12px;
        }

        #custom-hypridle.active {
            color: @base05;
        }

        #custom-hypridle.notactive {
            color: #dc2f2f;
        }

        #custom-ml4w-welcome {
            margin-right: 12px;
            background-image: url("../assets/ml4w-icon.svg");
            background-position: center;
            background-repeat: no-repeat;
            background-size: contain;
            padding-right: 20px;
        }

        #custom-chatgpt {
            margin-right: 16px;
            background-image: url("../assets/openai.svg");
            background-repeat: no-repeat;
            background-position: center;
            background-size: contain;
            padding-right: 18px;
            opacity: 0.8;
        }

        /* -----------------------------------------------------
        * Idle Inhibator
        * ----------------------------------------------------- */

        #idle_inhibitor {
            margin-right: 15px;
            font-size: 22px;
            font-weight: bold;
            opacity: 0.8;
            color: @base05;
        }

        #idle_inhibitor.activated {
            margin-right: 15px;
            font-size: 20px;
            font-weight: bold;
            opacity: 0.8;
            color: #dc2f2f;
        }

        /* -----------------------------------------------------
        * Custom Modules
        * ----------------------------------------------------- */

        #custom-appmenu {
            background-color: @base00;
            font-size: 16px;
            color: @base05;
            border-radius: 15px;
            padding: 0px 10px 0px 10px;
            margin: 3px 17px 3px 0px;
            opacity:0.8;
            border:3px solid @base02;
        }

        /* -----------------------------------------------------
        * Custom Notification
        * ----------------------------------------------------- */

        #custom-notification {
            margin: 0px 13px 0px 0px;
            padding:0px;
            font-size:20px;
            color: @base05;
            opacity: 0.8;
        }

        /* -----------------------------------------------------
        * Custom Exit
        * ----------------------------------------------------- */

        #custom-exit {
            margin: 0px 13px 0px 0px;
            padding:0px;
            font-size:20px;
            color: @base05;
            opacity: 0.8;
        }

        /* -----------------------------------------------------
        * Custom Updates
        * ----------------------------------------------------- */

        #custom-updates {
            background-color: @base00;
            font-size: 16px;
            color: @base04;
            border-radius: 15px;
            padding: 2px 10px 0px 10px;
            margin: 5px 15px 5px 0px;
            opacity:0.8;
        }

        #custom-updates.green {
            background-color: @base00;
        }

        #custom-updates.yellow {
            background-color: #ff9a3c;
            color: #FFFFFF;
        }

        #custom-updates.red {
            background-color: #dc2f2f;
            color: #FFFFFF;
        }

        /* -----------------------------------------------------
        * Hardware Group
        * ----------------------------------------------------- */

        #disk,#memory,#cpu,#language {
            margin:0px;
            padding:0px;
            font-size:16px;
            color:@base05;
        }

        #language {
            margin-right:10px;
        }

        /* -----------------------------------------------------
        * Clock
        * ----------------------------------------------------- */

        #clock {
            background-color: @base00;
            font-size: 16px;
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
            font-size: 16px;
            color: @base04;
            border-radius: 15px;
            padding: 2px 10px 0px 10px;
            margin: 5px 15px 5px 0px;
            opacity:0.8;
        }

        /* -----------------------------------------------------
        * Pulseaudio
        * ----------------------------------------------------- */

        #pulseaudio {
            background-color: @base00;
            font-size: 16px;
            color: @base04;
            border-radius: 15px;
            padding: 2px 10px 0px 10px;
            margin: 5px 15px 5px 0px;
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
            font-size: 16px;
            color: @base04;
            border-radius: 15px;
            padding: 2px 10px 0px 10px;
            margin: 5px 15px 5px 0px;
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
            font-size: 16px;
            color: @base04;
            border-radius: 15px;
            padding: 2px 10px 0px 10px;
            margin: 5px 15px 5px 0px;
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
            font-size: 16px;
            color: @base04;
            border-radius: 15px;
            padding: 2px 15px 0px 10px;
            margin: 5px 15px 5px 0px;
            opacity:0.8;
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
            padding: 0px 15px 0px 0px;
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
