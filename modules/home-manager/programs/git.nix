{ lib, config, secrets, ... }:

with lib;

let
  module-category = "programs"; # Category the module falls in
  module-name = "git"; # Name of the module
  cfg = config.snowman.${module-category}.${module-name}; # Config path
in {
  # --- Set options
  options.snowman.${module-category}.${module-name} = {
    enable = mkEnableOption "Configures git for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
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
