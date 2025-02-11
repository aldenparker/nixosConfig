{ lib, config, pkgs, ... }:

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
    # Install neofetch for startup
    home.packages = with pkgs; [
      neofetch
    ];      
  
    # Configure zsh, must enable nixos package version as well for default shell behavior
    programs.zsh = {
      # Basic Config values
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = "neofetch"; # Neofetch runs on terminal startup

      # Enable oh-my-zsh
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };

      # Aliases
      shellAliases = {
        nix-up-all = "nix-up; home-up";
        nix-clean = "sudo nix-collect-garbage --delete-older-than 10d";
        nix-clean-all = "sudo nix-collect-garbage -d";
      };

      # Source functions in env
      envExtra = "source .config/zsh/custom-zsh-functions";
    };

    # Add zsh functions to home folder
    home.file.".config/zsh/custom-zsh-functions".source = ./zsh-functions;
  };
}
