{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.bundles.bluetooth; # Config path
in
{
  # --- Set options
  options.${namespace}.bundles.bluetooth = {
    enable = mkEnableOption "Enables bluetooth for host";
    enableAudio = mkEnableOption "Enables bluetooth audio for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # --- Bluetooth
    hardware.bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };

    # --- System Applications
    environment.systemPackages = mkIf cfg.enableAudio [
      pkgs.bluez # Bluetooth support
      pkgs.bluez-tools # Bluetooth tools
    ];
  };
}
