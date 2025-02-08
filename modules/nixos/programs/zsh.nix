{ lib, config, pkgs, ... }:

with lib;

{
  # --- Set options
  options = {
    enable = mkEnableOption "Installs zsh for host and makes it the default shell";
  };

  # --- Set configuration
  config = mkIf config.enable {
      # Module installs and makes zsh the default shell for system
      environment.systemPackages = with pkgs; [ zsh ];
      users.defaultUserShell = pkgs.zsh;
    };
}
