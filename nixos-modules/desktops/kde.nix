{
  lib,
  config,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.desktops.kde; # Config path
in
{
  # --- Set options
  options.${namespace}.desktops.kde = {
    enable = mkEnableOption "Installs kde desktop and all basic desktop features";
    x11 = mkEnableOption "Enables x11 for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Enable gdm for display manager
    services.xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services.xserver.enable = mkIf cfg.x11 true;
    services.xserver.xkb = mkIf cfg.x11 {
      layout = "us";
      variant = "";
    };

    # Always exclude xterm
    services.xserver.excludePackages = mkIf cfg.x11 [ pkgs.xterm ];

    # Enable the KDE Plasma Desktop Environment.
    services.desktopManager.plasma6.enable = true;

    # Install fix for cursor size
    environment.systemPackages = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    # Disable unwanted optionals
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole # Terminal
      kate # Text Editor
    ];

    # Install gui essential packages
    ${namespace}.pkg-bundles.gui-essentials.enable = true;
  };
}
