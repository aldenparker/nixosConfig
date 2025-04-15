{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.niri; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.niri = {
    enable = mkEnableOption "Enables niri for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Install Niri and Make electron use Waland
    programs.niri.enable = true;
    environment.variables.NIXOS_OZONE_WL = "1";

    # Install packages needed for a solid dektop environment (will be configured using home-manager module like niri)
    environment.systemPackages = with pkgs; [
      fuzzel # App Launcher
      xwayland-satellite-unstable # Xwayland Support
      swaybg # Background Daemon
      waypaper # Background GUI
      pavucontrol # Audio GUI
      blueman # Bluetooth GUI
      networkmanagerapplet # Wifi GUI
      wdisplays # Display Managment GUI
      kanshi # Display Managment Dynamic Config
      mission-center # Task Manager
    ];

    ${namespace}.programs.swayosd.enable = true; # For volume and brightness controll and display
  };
}
