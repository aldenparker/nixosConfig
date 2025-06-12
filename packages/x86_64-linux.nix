{ pkgs }:

{
  cyberchef = pkgs.callPackage ./cyberchef.nix { };
  xnconvert = pkgs.callPackage ./xnconvert.nix { };
  nushellPlugins = {
    clipboard = pkgs.callPackage ./nu_plugin_clipboard.nix { };
  };
}
