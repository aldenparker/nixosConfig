{
  pkgs,
  lib,
  config,
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
    enable = mkEnableOption "Installs niri desktop and all basic desktop features";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Enable gdm for display manager
    services.xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    # Install Niri and Make electron use Waland
    programs.niri.enable = true;
    environment.variables.NIXOS_OZONE_WL = "1";

    # Install packages needed for a solid dektop environment (will be configured using home-manager module like niri)
    environment.systemPackages = with pkgs; [
      gparted # GUI Partitioner
      fuzzel # App Launcher
      xwayland-satellite # Xwayland Support
      swww # Background Daemon
      waypaper # Background GUI
      waybar # Status Bar
      mako # Notifications
      libnotify # Start notifications from terminal
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
      tauon # Music Player
      picard # Music Tagger
      swayosd # Volume and Brightness GUI
      gedit # Simple text editor
      kitty # Terminal
      zed-editor # Full code editor
    ];

    # Create startup service for swayOSD
    systemd.services.swayosd-libinput-backend = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
        Restart = "always";
      };
    };

    security.pam.services.swaylock = { }; # For enabling pam for screen unlock

    # Add fonts for all languages and needs
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

    # Install thunar for file explorer
    ${namespace}.programs = {
      thunar.enable = true;
    };
  };
}
