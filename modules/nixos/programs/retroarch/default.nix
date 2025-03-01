{ lib, inputs, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.retroarch; # Config path
in {
  # --- Set options
  options.${namespace}.programs.retroarch = {
    enable = mkEnableOption "Enables retroarh for host with default cores";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (retroarch.override {
        cores = with libretro; [
          desmume2015
          mgba
        ];
      })
    ];
  };
}
