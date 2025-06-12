{ pkgs }:

{
  cyberchef = pkgs.callPackage ./cyberchef.nix { };
  xnconvert = pkgs.callPackage ./xnconvert.nix { };
  nu_plugin_clipboard = pkgs.callPackage ./nu_plugin_clipboard.nix { };
  nu_plugin_emoji = pkgs.callPackage ./nu_plugin_emoji.nix { };
  nu_plugin_vec = pkgs.callPackage ./nu_plugin_vec.nix { };
  nu_plugin_desktop_notifications = pkgs.callPackage ./nu_plugin_desktop_notifications.nix { };
}
