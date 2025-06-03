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
  libreofficeWithFix = pkgs.libreoffice-qt6-fresh.overrideAttrs (
    final: prev: {
      postInstall =
        (prev.postInstall or "")
        + ''
          # Fix Scaling on Secondary Monitors
          for file in $out/lib/libreoffice/share/xdg/*.desktop; do
            substituteInPlace $file \
              --replace-fail "Exec=libreoffice" "Exec=env QT_QPA_PLATFORM=xcb libreoffice"
          done
        '';
    }
  );
in
{
  # --- Set options
  options.${namespace}.programs.libreoffice = {
    enable = mkEnableOption "Installs libreoffice with fixes";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libreofficeWithFix
      hunspell # For spell check
      hunspellDicts.en_US
    ];
  };
}
