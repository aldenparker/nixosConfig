{ pkgs }:

{
  cyberchef = pkgs.callPackage ./cyberchef.nix { };
  nushellPlugins = {
    clipboard = pkgs.callPackage ./nu_plugin_clipboard.nix { };
    emoji = pkgs.callPackage ./nu_plugin_emoji.nix { };
    vec = pkgs.callPackage ./nu_plugin_vec.nix { };
  };
}
