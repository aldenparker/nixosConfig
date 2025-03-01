{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.keymapp; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.keymapp = {
    enable = mkEnableOption "Enables keymapp for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # --- Keyboard support
    hardware.keyboard.zsa.enable = true;

    # --- System packages (no config)
    environment.systemPackages = with pkgs; [
      keymapp
    ];
  };
}
