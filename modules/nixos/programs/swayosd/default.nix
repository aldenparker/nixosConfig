{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.swayosd; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.swayosd = {
    enable = mkEnableOption "Installs swayosd and configures systemd";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      swayosd
    ];

    systemd.services.swayosd-libinput-backend = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
        Restart = "always";
      };
    };
  };
}
