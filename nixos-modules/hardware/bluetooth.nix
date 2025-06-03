{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.hardware.bluetooth; # Config path
in
{
  # --- Set options
  options.${namespace}.hardware.bluetooth = {
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
    environment.systemPackages =
      with pkgs;
      mkIf cfg.enableAudio [
        bluez # Bluetooth support
        bluez-tools # Bluetooth tools
      ];
  };
}
