{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.hardware.zsa; # Config path
in
{
  # --- Set options
  options.${namespace}.hardware.zsa = {
    enable = mkEnableOption "Installs zsa keyboard support and keymapp";
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
