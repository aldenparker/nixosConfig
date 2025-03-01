{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.libreoffice; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.libreoffice = {
    enable = mkEnableOption "Enables libreoffice for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libreoffice-qt
      hunspell # For spell check
      hunspellDicts.en_US
    ];
  };
}
