{
  lib,
  config,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.git; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.git = {
    enable = mkEnableOption "Configures git, setting up oauth";

    userName = mkOption {
      type = types.str;
      description = "The name to use to sign commits";
    };

    userEmail = mkOption {
      type = types.str;
      description = "The email to use to sign commits";
    };

    userGithubToken = mkOption {
      type = types.str;
      description = "The Github token to use to authenticate the user";
    };
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = "/etc/nixos"; # Allows for configs to be owned by root

        # Oauth setup
        url = {
          "https://oauth2:${cfg.userGithubToken}@github.com" = {
            insteadOf = "https://github.com";
          };
        };
      };
    };
  };
}
