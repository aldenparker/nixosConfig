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
      kitty.enable = true;
      zed.enable = true;

      git = {
        enable = true;
        userName = "Alden Parker";
        userEmail = "ajparker1401@gmail.com";
        userGithubToken = secrets.git.githubToken;
      };

      zsh = {
        enable = true;
        useAsNixShell = true;
      };
    };

    desktops = {
      niri.enable = true;
    };

    themes = {
      gruvbox.enable = true;
    };
  };

  # --- User setup
  home.username = "odin";
  home.homeDirectory = "/home/odin";

  # --- Home Manager Version - WARNING: HERE BE DRAGONS
  home.stateVersion = "25.05";
}
