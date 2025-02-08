{ lib, config, ... }:

with lib;

{
  # --- Set options
  options = {
    enable = mkEnableOption "Configures Zsh for host";
  };

  # --- Set configuration
  config = mkIf config.enable {
      # Configure zsh, must enable nixos package version as well for default shell behavior
      programs.zsh = {
        # Basic Config values
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        # Enable oh-my-zsh
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" ];
          theme = "robbyrussell";
        };

        # Aliases
        shellAliases = {
          nix-up = ''
            (){ 
                today=`date +%m.%d.%Y-%H.%M`
                branch=`(cd /etc/nixos ; git branch 2>/dev/null | sed -n '/^* / { s|^* ||; p; }')`
                sudo nixos-rebuild switch --profile-name $today.$branch --flake /etc/nixos/#$1
            ;}'';
          nix-up-labeled = ''
            (){ 
                today=`date +%m.%d.%Y-%H.%M`
                branch=`(cd /etc/nixos ; git branch 2>/dev/null | sed -n '/^* / { s|^* ||; p; }')`
                sudo nixos-rebuild switch --profile-name $today.$branch.$1 --flake /etc/nixos/#$2
            ;}'';
          nix-init-mod = "(){ sudo cp /etc/nixos/templates/module.nix ./$1 ;}";
        };
      };
    };
}
