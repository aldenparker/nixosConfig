{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.zsh; # Config path
in {
  # --- Set options
  options.${namespace}.programs.zsh = {
    enable = mkEnableOption "Configures zsh for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Install neofetch for startup
    home.packages = with pkgs; [ neofetch ];

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
        nix-clean = "sudo nix-collect-garbage --delete-older-than 10d";
        nix-clean-all = "sudo nix-collect-garbage -d";
      };
    };
  };
}