{
  lib,
  config,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.desktops.gnome; # Config path
in
{
  # --- Set options
  options.${namespace}.desktops.gnome = {
    enable = mkEnableOption "Installs gnome desktop and all basic desktop features";
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

    # Enable gnome
    services.xserver.desktopManager.gnome.enable = true;

    # Install replacement for exluded packages that are required
    environment.systemPackages = with pkgs; [
      kitty # Terminal
      zed # Text Editor
      kdePackages.elisa # Music Player
    ];

    # Disable unwanted optionals
    environment.gnome.excludePackages = (
      with pkgs;
      [
        atomix # puzzle game
        cheese # webcam tool
        epiphany # web browser
        evince # document viewer
        geary # email reader
        gedit # text editor
        gnome-characters
        gnome-music
        gnome-photos
        gnome-terminal
        gnome-tour
        hitori # sudoku game
        iagno # go game
        tali # poker game
        totem # video player
      ]
    );
  };
}
