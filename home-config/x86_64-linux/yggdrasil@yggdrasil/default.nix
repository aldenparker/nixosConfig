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

  # --- Configure glance folder (Manual link instead of home amnager module due to assets needed)
  home.file.".glance" = {
    source = ./glance;
    recursive = true;
  };

  # --- User setup
  home.username = "yggdrasil";
  home.homeDirectory = "/home/yggdrasil";

  # --- Home Manager Version -  WARNING: HERE BE DRAGONS
  home.stateVersion = "25.05";
}
