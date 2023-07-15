{ lib
, stdenv
, meson
, ninja
, pkg-config
, glib
, libfprint
, polkit
, dbus
, systemd
, pam
, libpam-wrapper
, fetchFromGitLab
}:

stdenv.mkDerivation rec {
  pname = "pam-fprint-grosshack";
  version = "v0.3.0";

  src = fetchFromGitLab {
    owner = "mishakmak";
    repo = pname;
    rev = version;
    sha256 = "sha256-obczZbf/oH4xGaVvp3y3ZyDdYhZnxlCWvL0irgEYIi0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
    libfprint
    polkit
    dbus
    systemd
    pam
    libpam-wrapper
  ];
  
  mesonFlags = [
    "-Dpam_modules_dir=${placeholder "out"}/lib/security"
    "-Dsysconfdir=${placeholder "out"}/etc"
    "-Ddbus_service_dir=${placeholder "out"}/share/dbus-1/system-services"
    "-Dsystemd_system_unit_dir=${placeholder "out"}/lib/systemd/system"
  ];
}
