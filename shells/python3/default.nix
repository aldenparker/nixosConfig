{
  pkgs,
  mkShell,
  ...
}:

# Default python3 shell with the essential packages
let
  python = pkgs.python3.withPackages(p: [
    p.numpy
    p.matplotlib
    p.requests
  ]);
in mkShell {
  # Create your shell
  packages = [
    python
  ];
}