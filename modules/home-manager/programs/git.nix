{ lib, config, secrets, ... }:

with lib;

let
  module-type = "hm"; # home-manager (hm) vs nixos (nx)
  module-category = "programs"; # category the module falls in, usually the name of the folder it is in
  module-name = "git"; # Name of the module
in {
  # --- Set options
  options.snowman.${module-type}.${module-category}.${module-name} = {
    enable = mkEnableOption "Enables ${module-name} for host";
  };

  # --- Set configuration
  config = mkIf config.snowman.${module-type}.${module-category}.${module-name}.enable {
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
