{
  stdenv,
  lib,
  fetchgit,
  desktop-file-utils,
  wrapGAppsHook3,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  addDriverRunpath,
  # mgl (base graphics lib) deps
  pango,
  glib,
  libX11,
  libXrender,
  libXrandr,
  libdecor,
  wayland,
  libxkbcommon,
  libglvnd,
  # gsr-ui direct deps
  libXcomposite,
  libXfixes,
  libXext,
  libXi,
  libXcursor,
  libpulseaudio,
  libdrm,
  # helper tool deps
  dbus,
  # runtime
  gpu-screen-recorder,
  libjpeg_turbo,
  wrapperDir ? "/run/wrappers/bin",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder-ui";
  version = "1.12.2";

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-ui";
    rev = "44b56500c332722d39771129245d61b6535cb603";
    fetchSubmodules = false;
    hash = "sha256-kCNSxQPqi3EO2JWh3tiiUoAu4cXPN3WOdjmyqZtvM+M=";
  };

  # Vendored subprojects — meson subproject_dir is "depends"
  mglppSrc = fetchgit {
    url = "https://repo.dec05eba.com/mglpp";
    rev = "034397e7d6d998b87ba3e156691fc840bbed3372";
    fetchSubmodules = false;
    hash = "sha256-qJhWQptyX0aWAgqFOLFcY9Aq8QY7/LkckEVkek/to+Q=";
  };

  mglSrc = fetchgit {
    url = "https://repo.dec05eba.com/mgl";
    rev = "ee5f5eef25eeb9b09e052e237788e660444f7e81";
    fetchSubmodules = false;
    hash = "sha256-v/LH5J0sV+1fGB6hGr4Ju73IKWX04ZTx1hrk16QGHDU=";
  };

  postUnpack = ''
    mkdir -p "$sourceRoot/depends/mglpp"
    cp -r --no-preserve=mode "$mglppSrc/." "$sourceRoot/depends/mglpp/"
    mkdir -p "$sourceRoot/depends/mglpp/depends/mgl"
    cp -r --no-preserve=mode "$mglSrc/."   "$sourceRoot/depends/mglpp/depends/mgl/"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    desktop-file-utils
    wrapGAppsHook3
  ];

  buildInputs = [
    # mgl base deps
    pango
    glib
    libX11
    libXrender
    libXrandr
    libdecor
    wayland
    libxkbcommon
    libglvnd
    # gsr-ui direct deps
    libXcomposite
    libXfixes
    libXext
    libXi
    libXcursor
    libpulseaudio
    libdrm
    dbus
  ];

  mesonFlags = [
    (lib.mesonBool "capabilities" false)
    (lib.mesonBool "desktop-files" true)
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${
      lib.makeLibraryPath [
        libglvnd
        addDriverRunpath.driverLink
        libjpeg_turbo
      ]
    }")
    gappsWrapperArgs+=(--prefix PATH : "${wrapperDir}")
    gappsWrapperArgs+=(--suffix PATH : "${lib.makeBinPath [gpu-screen-recorder]}")
  '';

  meta = {
    description = "ShadowPlay-style overlay UI for gpu-screen-recorder (non-GTK)";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-ui/about/";
    license = lib.licenses.gpl3Only;
    mainProgram = "gsr-ui";
    platforms = lib.platforms.linux;
  };
})
