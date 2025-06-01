{
  lib,
  config,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.bundles.audio; # Config path
in
{
  # --- Set options
  options.${namespace}.bundles.audio = {
    enable = mkEnableOption "Enables audio for host";
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
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
  };
}
