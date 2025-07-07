{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation rec {

  pname = "ktoggle";
  version = "0.0.0";

  src = pkgs.fetchgit {
    url = "https://codeberg.org/tubbadu/ktoggle";
    rev = "4b7d7eea92a3cb1ffaf3d3d72c6d72b0b82411ed";
    sha256 = "sha256-VDyPO+CNxWoGmgPWOgzW8tHi+ygL0/jtCyqM3QJbC+U=";
    fetchSubmodules = false;
  };

  singleAppSrc = pkgs.fetchFromGitHub {
    owner = "itay-grudev";
    repo = "SingleApplication";
    rev = "v3.5.2";
    sha256 = "sha256-OwfAikUJ+rC0BSLXILs0fBd1ilzu31ghMslwrgbnKhk=";
  };

  nativeBuildInputs =
    with pkgs;
    [
      cmake
      extra-cmake-modules
      makeWrapper
      qt5.qtbase
      qt5.qtquickcontrols2
    ]
    ++ (with libsForQt5; [
      kirigami2
      ki18n
      kcoreaddons
      kwindowsystem
      kwayland
      kiconthemes
      wrapQtAppsHook
    ]);

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_PREFIX_PATH=${pkgs.qt5.qtbase}/lib/cmake/Qt5"
  ];

  postUnpack = ''
    rm -r "$sourceRoot/src/SingleApplication"
    ln -s "${singleAppSrc}" "$sourceRoot/src/SingleApplication"
  '';

  meta = {
    description = "A tool to quickly toggle the visibility of windows in KDE";
    homepage = "https://github.com/tubbadu/ktoggle";
  };

  enableParallelBuilding = true;

}
