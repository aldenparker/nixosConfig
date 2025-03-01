{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.zsh; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.zsh = {
    enable = mkEnableOption "Installs zsh for host and makes it the default shell";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Module installs and makes zsh the default shell for system
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
  };
}
