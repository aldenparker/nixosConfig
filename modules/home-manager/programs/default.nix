{ ... }:

{
  imports = [
    # --- Import all individual programs
    ./git.nix
    ./neovim.nix
    ./zsh.nix

    # --- Import all spread programs (programs that need multiple nix files)
  ];
}
