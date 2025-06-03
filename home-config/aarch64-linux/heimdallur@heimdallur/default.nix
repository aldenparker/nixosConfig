{
  secrets,
  ...
}:
{
  imports = [ ];

  # --- Configure snowman modules (my custom modules)
  snowman = {
    # --- Configure individual packages
    programs = {
      git = {
        enable = true;
        userName = "Alden Parker";
        userEmail = "ajparker1401@gmail.com";
        userGithubToken = secrets.git.githubToken;
      };

      zsh.enable = true;
      kitty.enable = true;
    };
  };

  # --- User setup
  home.username = "heimdallur";
  home.homeDirectory = "/home/heimdallur";

  # --- Home Manager Version -  WARNING: HERE BE DRAGONS
  home.stateVersion = "25.05";
}
