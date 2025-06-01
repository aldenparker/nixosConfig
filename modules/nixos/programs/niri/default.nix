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
      swww # Background Daemon
      waypaper # Background GUI
      swaylock-effects # Screen locker
      pavucontrol # Audio GUI
      blueman # Bluetooth GUI
      networkmanagerapplet # Wifi GUI
      wdisplays # Display Managment GUI
      kanshi # Display Managment Dynamic Config
      mission-center # Task Manager
      selectdefaultapplication # Default appliation manager
      xdg-desktop-portal-gtk # For file picker portal (needs to be configured)
      kdePackages.ark # Archive manager
      eog # Image viewer
    ];

    security.pam.services.swaylock = { }; # For enabling pam for screen unlock
    ${namespace}.programs.swayosd.enable = true; # For volume and brightness controll and display

    # Add japanese support - 私はアルデンテ。
    i18n.inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc # Japanese plugin
          fcitx5-gtk # GTK integration
          fcitx5-nord # Color Theme
        ];
      };
    };

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
    ];
  };
}
