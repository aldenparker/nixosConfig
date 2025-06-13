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

    # Install Niri and make electron use Waland
    programs.niri = {
      enable = true;
      package = pkgs.niri; # TODO: Can be removed on niri flake update
    };
    environment.variables.NIXOS_OZONE_WL = "1";

    # Install packages needed for a solid dektop environment (will be configured using home-manager module like niri)
    environment.systemPackages = with pkgs; [
      fuzzel # App Launcher
      xwayland-satellite # Xwayland Support
      swww # Background Daemon
      waypaper # Background GUI
      waybar # Status Bar
      swaynotificationcenter # Notifications
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
      swayosd # Volume and Brightness GUI
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

    # --- fcitx5 for multi language support - 私はアルデンテ。
    i18n.inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc # Japanese plugin
          fcitx5-gtk # GTK integration
          libsForQt5.fcitx5-qt # QT integration
        ];
      };
    };

    # Install thunar for file explorer and essential gui applications
    ${namespace} = {
      programs.thunar.enable = true;
      pkg-bundles.gui-essentials.enable = true;
    };
  };
}
