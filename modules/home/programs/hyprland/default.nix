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
      	"$mod" = "SUPER";
      	"monitor" = ",preferred,auto,1";
      	bind = [
          "$mod, Q, killactive"
      		"$mod, Return, exec, kitty"
      		"$mod, W, exec, librewolf"
      		"$mod_SHIFT, Return, exec, wofi --show drun"
      	];
      	exec-once = [
      		"killall -q swww-daemon; sleep .5 && swww-daemon"
          "killall -q waybar; sleep .5 && waybar"
          "killall -q nm-applet; sleep .5 && nm-applet"
      	];
      };
    };
  };
}
