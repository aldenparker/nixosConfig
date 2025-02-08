{ lib, config, pkgs, ... }:

with lib;

let
  module-category = "programs"; # Category the module falls in
  module-name = "zsh"; # Name of the module
  cfg = config.snowman.${module-category}.${module-name}; # Config path
in {
  # --- Set options
  options.snowman.${module-category}.${module-name} = {
    enable = mkEnableOption "Installs zsh for host and makes it the default shell";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
      # Module installs and makes zsh the default shell for system
      environment.systemPackages = with pkgs; [ zsh ];
      users.defaultUserShell = pkgs.zsh;
    };
}
