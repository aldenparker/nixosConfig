{
  flake-inputs,
  system,
  pkgs,
  mkShell,
}:

# Create zig-master shell
let
  zig = flake-inputs.zig-overlay.packages.${system}.master;
  zls = flake-inputs.zls-overlay.packages.${system}.zls;
in
mkShell {
  packages = with pkgs; [
    zig
    zls
    lldb
  ];
}
