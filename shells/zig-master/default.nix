{
  inputs,
  system,
  pkgs,
  mkShell,
  ...
}:

# Create zig-master shell
let
  zig = inputs.zig-overlay.packages.${system}.master;
  zls = inputs.zls-overlay.packages.${system}.zls.overrideAttrs (old: {
    nativeBuildInputs = [ zig ];
  });
in mkShell {
  packages = with pkgs; [
    zig
    # zls # TODO: fix zls build with help of zigget post https://ziggit.dev/t/zls-on-nixos-fails-to-build/8810
    lldb
  ];
}