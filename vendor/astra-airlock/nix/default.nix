{
  lib,
  stdenv,
  cmake,
  ninja,
  pkg-config,
  qt6,
  quickshell,
  m3shapes,
  makeWrapper,
  wlr-randr,
  airlockVersion,
}:
stdenv.mkDerivation {
  pname = "astra-airlock";
  version = airlockVersion;

  src = ./..;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    makeWrapper
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtquick3d
    m3shapes
];

  cmakeFlags = [
    "-DFETCHCONTENT_SOURCE_DIR_M3SHAPES_EXTERNAL=${m3shapes.src}"
    "-DINSTALL_QSCONFDIR=etc/xdg/quickshell/astra-airlock"
    "-DASTRA_AIRLOCK_VERSION=${airlockVersion}"
  ];

  postInstall = ''
    wrapProgram $out/bin/astra-airlock \
      --prefix PATH : ${lib.makeBinPath [ quickshell wlr-randr ]} \
      --prefix QML2_IMPORT_PATH : "${m3shapes}/lib/qt-6/qml:$out/lib/qt6/qml:$QML2_IMPORT_PATH"
  '';

  meta = with lib; {
    description = "A Quickshell frontend for greetd matching Caelestia M3 design";
    homepage = "https://github.com/AstraSuite/Airlock";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
