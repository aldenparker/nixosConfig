{
  pkgs,
  mkShell,
}:

# Creates node / javascript / typescript shell
mkShell {
  packages = with pkgs; [
    node2nix
    nodejs
    nodePackages.pnpm
    yarn
  ];
}
