{ lib, config, secrets, ... }:

with lib;

{
  # --- Set options
  options = {
    enable = mkEnableOption "Enables Git for host";
  };

  # --- Set configuration
  config = mkIf config.enable {
      programs.git = {
        enable = true;
        userName = "Alden Parker";
        userEmail = "ajparker1401@gmail.com";
        extraConfig = {
          init.defaultBranch = "main";
          safe.directory = "/etc/nixos"; # Allows for configs to be owned by root

          # Oauth setup
          url = {
            "https://oauth2:${secrets.github.oauth_token}@github.com" = {
              insteadOf = "https://github.com";
            };
          };
        };
      };
    };
}
