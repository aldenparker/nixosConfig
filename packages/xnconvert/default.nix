{
  lib,
  stdenv,
  fetchurl,
  openexr_3,
  gcc-unwrapped,
  qt5,
  gtk3,
  libGLU,
  libGL,
  pango,
  autoPatchelfHook,
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

  nativeBuildInputs = [
    openexr_3
    gcc-unwrapped.libgcc 
    qt5.wrapQtAppsHook
    gtk3 
    libGLU
    libGL
    pango 
    autoPatchelfHook
  ];

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
    description = "XnConvert is a fast, powerful and free cross-platform batch image converter. It allows to automate editing of your photo collections: you can rotate, convert and compress your images, photos and pictures easily, and apply over 80 actions (like resize, crop, color adjustments, filter, ...). All common picture and graphics formats are supported (JPEG, TIFF, PNG, GIF, WebP, PSD, JPEG2000, JPEG-XL, OpenEXR, camera RAW, HEIC, PDF, DNG, CR2). You can save and re-use your presets for another batch image conversion.";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    # maintainers = with lib.maintainers; [ aldenparker ];
  };
}