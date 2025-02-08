{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  nvf,
  ...
}: {
  imports = [
    # Import custom modules
    outputs.homeManagerModules

    # Import base
    ./base.nix
  ];

  # --- Configure snowman modules (my custom modules)
  snowman = {
    # --- Configure individual packages
    programs = {
      git.enable = true;
      neovim.enable = true;
      zsh.enable = true;
    };
  };

  # --- User setup
  home.username = "msroot";
  home.homeDirectory = "/home/msroot";

  # --- Home Manager Version -  WARNING: HERE BE DRAGONS
  home.stateVersion = "24.11";
}
