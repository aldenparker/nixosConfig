{ lib, inputs, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.kde; # Config path
in {
  # --- Set options
  options.${namespace}.programs.kde = {
    enable = mkEnableOption "Enables kde for host";
    x11 = mkEnableOption "Enables x11 for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services.xserver = mkIf cfg.x11 {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Enable the KDE Plasma Desktop Environment.
    services.desktopManager.plasma6.enable = true;

    # Disable unwanted optionals
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      kate
    ];
  };
}
