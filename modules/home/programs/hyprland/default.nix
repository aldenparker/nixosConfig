{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.hyprland; # Config path
in {
  # --- Set options
  options.${namespace}.programs.hyprland = {
    enable = mkEnableOption "Configures hyprland for the host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Hyprland config
    wayland.windowManager.hyprland = {
      enable = true; # enable Hyprland
      settings = {
        general = {
          gaps_in = 10;
          gaps_out = 14;
          border_size = 3;
          layout = "dwindle";
          resize_on_border = true;
          "col.active_border" = mkForce "0x${config.lib.stylix.colors.base0D}";
          "col.inactive_border"  = mkForce "0x${config.lib.stylix.colors.base03}";
        };

        decoration = {
          rounding = 10;
          active_opacity = 1.0;
          inactive_opacity = 0.8;
          fullscreen_opacity = 1.0;

          blur = {
            enabled = true;
            size = 6;
            passes = 2;
            new_optimizations = "on";
            ignore_opacity = true;
            xray = true;
          };

          shadow = {
            enabled = true;
            range = 30;
            render_power = 3;
            color = mkForce "0x66000000";
          };
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 3;
          workspace_swipe_distance = 500;
          workspace_swipe_invert = true;
          workspace_swipe_min_speed_to_force = 30;
          workspace_swipe_cancel_ratio = 0.5;
          workspace_swipe_create_new = true;
          workspace_swipe_forever = true;
        };

        binds = {
          workspace_back_and_forth = true;
          allow_workspace_cycles = true;
          pass_mouse_when_bound = false;
        };

        windowrule = [
          "float,^(pavucontrol)$"
          "float,^(blueman-manager)$"
          "float,^(nm-connection-editor)$"
        ];

        # Browser Picture in Picture
        windowrulev2 = [
          "float, title:^(Picture-in-Picture)$"
          "pin, title:^(Picture-in-Picture)$"
          "move 69.5% 4%, title:^(Picture-in-Picture)$"
        ];

        animations = {
          enabled = true;
          bezier = [
            "linear, 0, 0, 1, 1"
            "md3_standard, 0.2, 0, 0, 1"
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.15"
            "overshot, 0.05, 0.9, 0.1, 1.1"
            "crazyshot, 0.1, 1.5, 0.76, 0.92"
            "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
            "fluent_decel, 0.1, 1, 0, 1"
            "easeInOutCirc, 0.85, 0, 0.15, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
            "easeOutExpo, 0.16, 1, 0.3, 1"
          ];
          animation = [
            "windows, 1, 3, md3_decel, popin 60%"
            "border, 1, 10, default"
            "fade, 1, 2.5, md3_decel"
            "workspaces, 1, 3.5, easeOutExpo, slide"
            "specialWorkspace, 1, 3, md3_decel, slidevert"
          ];
        };

        monitor = ",preferred,auto,1";

      	"$mod" = "SUPER";
      	bind = [
          "$mod, Q, killactive"
      		"$mod, Return, exec, kitty"
      		"$mod, W, exec, librewolf"
      		"$mod_SHIFT, Return, exec, wofi --show drun"
      	];

      	exec-once = [
      		"killall -q swww-daemon; sleep .5 && swww-daemon"
      		"killall -q blueman-applet; sleep .5 && blueman-applet"
          "killall -q waybar; sleep 1 && waybar"
          "killall -q nm-applet; sleep .5 && nm-applet"
          "killall -q swaync; sleep .5 && swaync"
      	];
      };
    };
  };
}
