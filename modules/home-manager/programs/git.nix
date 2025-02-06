{ lib, config, ... }:

with lib;

let 
  cfg = config.snowman.hm.programs.git;
in {
  options.snowman.hm.programs.git.enable = mkEnableOption "Enables Git for host";

  # --- Simple setup for Git
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Alden Parker";
      userEmail = "ajparker1401@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = "/etc/nixos"; # Allows for configs to be owned by root

        credential = {
          helper = "store";
          "https://github.com".username = "aldenparker";
        };
      };
    };
  };
}
