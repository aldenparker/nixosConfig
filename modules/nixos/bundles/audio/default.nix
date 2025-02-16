{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.bundles.audio; # Config path
in {
  # --- Set options
  options.${namespace}.bundles.audio = {
    enable = mkEnableOption "Enables audio for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # --- Audio
    hardware.pulseaudio.enable = false; # Use Pipewire, the modern sound subsystem

    security.rtkit.enable = true; # Enable RealtimeKit for audio purposes

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # --- System Applications
    environment.systemPackages = with pkgs; [
      pavucontrol # PulseAudio Volume Control
      pamixer # Command-line mixer for PulseAudio
    ];
  };
}
