{ lib, config, pkgs, ... }:

with lib;

let 
  cfg = config.snowman.nx.programs.zsh;
in {
  options.snowman.nx.programs.zsh.enable = mkEnableOption "Make zsh the default user shell";

  # --- Simple setup for zsh
  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
  };
}
