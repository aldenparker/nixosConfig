{ lib, config, ... }:

with lib;

let
  module-category = "programs"; # Category the module falls in
  module-name = "zsh"; # Name of the module
  cfg = config.snowman.${module-category}.${module-name}; # Config path
in {
  # --- Set options
  options.snowman.${module-category}.${module-name} = {
    enable = mkEnableOption "Configures zsh for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
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
