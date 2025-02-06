{ lib, config, ... }:

with lib;

let 
  cfg = config.snowman.hm.programs.zsh;
in {
  options.snowman.hm.programs.zsh.enable = mkEnableOption "Enables zsh for host";

  # --- Simple setup for Git
  config = mkIf cfg.enable {
    programs.zsh = {
      # Basic Config values
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # Enable oh-my-zsh
      oh-my-zsh = {
        enable = true;
        plugins = [ 
          "git"
        ];
        theme = "robbyrussell";
      };

      # Aliases
      shellAliases = {
        nix-up = "(){ sudo nixos-rebuild switch --flake /etc/nixos/#$1 ;}";
      };
    };
  };
}
