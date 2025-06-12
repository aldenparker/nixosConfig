{ pkgs }:

{
  cyberchef = pkgs.callPackage ./cyberchef.nix { };
  nushellPlugins = {
    clipboard = pkgs.callPackage ./nu_plugin_clipboard.nix { };
  };
}
