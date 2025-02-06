{ ... }:

{
  imports = [
    # --- Import all individual features
    ./git.nix

    # --- Import all spread features (features that run multiple nix files)
  ];
}
