{
  lib,
  inputs,
  namespace,
  pkgs,
  stdenv,
  fetchurl,
  ...
}:

stdenv.mkDerivation rec {
  name = "xnconvert";
  pname = "xnconvert";
  version = "latest";

  src = fetchurl {
    url = "https://download.xnview.com/XnConvert-linux-x64.tgz";
    sha256 = "sha256-oVAN030PdZZ3OvjbG4DsWQJ+JcmPLT4iHPhwPfgO4VY=";
  };

  nativeBuildInputs = with pkgs; [
    openexr_3
    gcc-unwrapped.libgcc 
    qt5.wrapQtAppsHook
    gtk3 
    libGLU
    libGL
    pango 
    autoPatchelfHook
  ];

  # buildInputs = with pkgs; [
  #   qt5.qtbase
  #   qt5.qtsvg
  # ] ++ lib.optional stdenv.hostPlatform.isLinux qt5.qtwayland;

  sourceRoot = ".";

  # Ignore broken deps
  autoPatchelfIgnoreMissingDeps = [
    "libOpenEXR-3_2.so.29"
    "libOpenEXRCore-3_2.so.29"
  ];

  # Patch dependency error
  postFixup = ''
    patchelf --replace-needed libOpenEXR-3_2.so.29 libOpenEXR-3_2.so.31 ./XnConvert/Plugins/libOpenEXRUtil-3_2.so 
    patchelf --replace-needed libOpenEXRCore-3_2.so.29 libOpenEXRCore-3_2.so.31 ./XnConvert/Plugins/libOpenEXRUtil-3_2.so 
  '';

  installPhase = ''
    install -m 444 -D ./XnConvert/xnconvert.png $out/share/icons/hicolor/64x64/apps/${pname}.png
    
    mkdir -p $out/share/applications
    cat <<INI > $out/share/applications/${name}.desktop
    [Desktop Entry]
    Encoding=UTF-8
    Terminal=0
    Exec=$out/opt/XnConvert/xnconvert.sh
    Icon=xnconvert.png
    Type=Application
    Categories=Graphics;
    StartupNotify=true
    Name=XnConvert
    GenericName=XnConvert
    INI

    rm ./XnConvert/XnConvert.desktop

    mkdir $out/opt/
    cp -a ./XnConvert/ $out/opt/
  '';

  meta = {
    homepage = "https://www.xnview.com/en/xnconvert";
    description = "A useful image converter";
    platforms = [ "x86_64-linux" ];
  };
}