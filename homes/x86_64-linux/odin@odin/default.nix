{
  secrets,
  ...
}:
{
  imports = [
    # Import base
    ../../base.nix
  ];

  # --- Configure snowman modules (my custom modules)
  snowman = {
    # --- Configure individual packages
    programs = {
      librewolf.enable = true;
      geany.enable = true;
      neovim.enable = true;
      kitty.enable = true;

      git = {
        enable = true;
        userName = "Alden Parker";
        userEmail = "ajparker1401@gmail.com";
        userGithubToken = secrets.git.githubToken;
      };

      zsh = {
        enable = true;
        fastfetch = {
          enable = true;
          kitty = true;
        };
      };
    };

    bundles = {
      gruvbox = {
        enable = true;
        kde = true;
      };
    };
  };

  # --- User setup
  home.username = "odin";
  home.homeDirectory = "/home/odin";

  # --- Home Manager Version - WARNING: HERE BE DRAGONS
  home.stateVersion = "24.11";
}
