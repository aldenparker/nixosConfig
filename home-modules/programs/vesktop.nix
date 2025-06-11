{
  lib,
  config,
  namespace,
  flake-inputs,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.vesktop; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.vesktop = {
    enable = mkEnableOption "Enable stylix themeing for vesktop without locking settings";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # --- Use stylix to generate theme for vesktop (this way settings can be used)
    home.file.".config/vesktop/themes/stylix.css".text =
      let
        template = import "${flake-inputs.stylix.outPath}/modules/discord/template.nix" {
          inherit (config.lib.stylix) colors;
          inherit (config.stylix) fonts;
        };
      in
      template;
  };
}
