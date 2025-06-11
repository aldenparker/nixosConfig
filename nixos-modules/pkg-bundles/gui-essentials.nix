{
  lib,
  config,
  namespace,
  pkgs,
  flake-inputs,
  system,
  ...
}:

with lib;

let
  cfg = config.${namespace}.pkg-bundles.gui-essentials; # Config path
in
{
  # --- Set options
  options.${namespace}.pkg-bundles.gui-essentials = {
    enable = mkEnableOption "Installs the set of gui packages I consider essential.";
    disableExtraEditors = mkEnableOption "Removes the set of gui editors for video, audio, images, and 3D models from the bundle.";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Fixes GTK unable to load svg icons
    programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

    environment.systemPackages =
      with pkgs;
      [
        flake-inputs.zen-browser.packages."${system}".default # Web browser
        qbittorrent # Torrenting
        vlc # Video Viewer
        keepassxc # Password Manager
        usbimager # USB Imager
        kdePackages.filelight # Disk Space Analyzer
        tor-browser # Secure Browser
        veracrypt # Encryption of Drives
        gnupg # Encryption of Files
        gedit # Simple text editor
        kitty # Terminal
        zed-editor # Full code editor
        gparted # GUI Partitioner
        eog # Image viewer
        tauon # Music Player
        picard # Music Tagger
        thunderbird # Email Client and Calender
      ]
      ++ (
        if !cfg.disableExtraEditors then
          [
            gimp3 # Photoshop
            inkscape # SVG
            krita # Image Editor / Art Studio
            davinci-resolve # Video Editing
            blender # 3D Editor
            audacity # Audio Editor
          ]
        else
          [ ]
      );
  };
}
