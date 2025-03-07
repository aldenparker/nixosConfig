{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.gnome; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.gnome = {
    enable = mkEnableOption "Enables gnome for host";
    x11 = mkEnableOption "Enables x11 for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
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

    # Install needed packages
    environment.systemPackages = with pkgs; [
      gnomeExtensions.paperwm
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
