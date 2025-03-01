{
  pkgs,
  mkShell,
  ...
}:

# Create zig-stable shell
mkShell {
  packages = with pkgs; [
    zig
    zls
    lldb
  ];
}
