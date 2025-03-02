{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.services.cloudflared; # Config path
in
{
  # --- Set options
  options.${namespace}.services.cloudflared = {
    enable = mkEnableOption "Installs cloudflared and configures for tunnel token";
    autostart = mkEnableOption "Enable if you want it to autostart";

    tunnelToken = mkOption {
      type = types.str;
      description = "The tunnel token";
    };
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    users.users.cloudflared = {
      group = "cloudflared";
      isSystemUser = true;
    };
    users.groups.cloudflared = { };

    systemd.services.cloudflared = {
      wantedBy = mkIf cfg.autostart [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token=${cfg.tunnelToken}";
        Restart = "no";
        User = "cloudflared";
        Group = "cloudflared";
      };
    };
  };
}
