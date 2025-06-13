{
  flake-inputs,
  system,
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  asusWmiScreenpad =
    flake-inputs.asus-wmi-screenpad.defaultPackage.${system}.override
      config.boot.kernelPackages.kernel;
  cfg = config.${namespace}.hardware.asus-wmi-screenpad; # Config path
in
{
  # --- Set options
  options.${namespace}.hardware.asus-wmi-screenpad = {
    enable = mkEnableOption "Installs the asus-wmi-screenpad kernel module for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # --- Custom kernel module setup
    boot.extraModulePackages = [ asusWmiScreenpad ];
    boot.kernelModules = [ "asus_wmi_screenpad" ];

    # Enable changing brightness without giving permission every time after reboot
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="leds", KERNEL=="asus::screenpad", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/leds/%k/brightness"
    '';

    # Install custom control program
    environment.systemPackages = [
      flake-inputs.self.packages.${system}.asus-wmi-screenpad-ctl
    ];
  };
}
