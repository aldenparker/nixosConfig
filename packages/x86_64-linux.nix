{ pkgs }:

{
  cyberchef = pkgs.callPackage ./cyberchef.nix { };
  xnconvert = pkgs.callPackage ./xnconvert.nix { };
  nushellPlugins = {
    clipboard = pkgs.callPackage ./nu_plugin_clipboard.nix { };
    emoji = pkgs.callPackage ./nu_plugin_emoji.nix { };
    vec = pkgs.callPackage ./nu_plugin_vec.nix { };
  };
}
