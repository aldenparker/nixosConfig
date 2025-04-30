{
  lib,
  appimageTools,
  fetchurl,
  ...
}:

let
  pname = "zen";
  version = "1.11.5b";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-x86_64.AppImage";
    sha256 = "sha256-vf6GSL5DRmDMpALt+ZwNuhNot7nDknqJNikW3QihAPE=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    # Install .desktop file
    install -m 444 -D ${appimageContents}/zen.desktop $out/share/applications/${pname}.desktop
    # Install icon
    install -m 444 -D ${appimageContents}/zen.png $out/share/icons/hicolor/128x128/apps/${pname}.png
  '';

  meta = {
    homepage = "https://zen-browser.app/";
    description = "Beautifully designed, privacy-focused, and packed with features. We care about your experience, not your data.";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mpl20;
    # maintainers = with lib.maintainers; [ aldenparker ];
  };
}
