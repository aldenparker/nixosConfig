{
  lib,
  config,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.hardware.audio; # Config path
in
{
  # --- Set options
  options.${namespace}.hardware.audio = {
    enable = mkEnableOption "Enables audio for host";
    enableJACK = mkEnableOption "Enables JACK applications";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # --- Audio
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = mkIf cfg.enableJACK true;
    };
  };
}
