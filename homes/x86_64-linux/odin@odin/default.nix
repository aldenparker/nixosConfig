{ inputs, lib, config, pkgs, secrets, ... }: {
  imports = [
    # Import base
    ../../base.nix
  ];

  # --- Configure snowman modules (my custom modules)
  snowman = {
    # --- Configure individual packages
    programs = {
      hyprland.enable = true;
      librewolf.enable = true;

      git = {
        enable = true;
        userName = "Alden Parker";
        userEmail = "ajparker1401@gmail.com";
        userGithubToken = secrets.git.githubToken;
      };

      neovim.enable = true;
      zsh.enable = true;
      kitty.enable = true;
    };
  };

  # --- User setup
  home.username = "odin";
  home.homeDirectory = "/home/odin";

  # --- Home Manager Version - WARNING: HERE BE DRAGONS
  home.stateVersion = "24.11";
}
