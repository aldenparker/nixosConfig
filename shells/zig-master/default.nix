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
  zls = inputs.zls-overlay.packages.${system}.zls;
in
mkShell {
  packages = with pkgs; [
    zig
    zls
    lldb
  ];
}
