{ pkgs }:

{
  cyberchef = pkgs.callPackage ./cyberchef.nix { };
  xnconvert = pkgs.callPackage ./xnconvert.nix { };
}
