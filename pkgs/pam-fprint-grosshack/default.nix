{
  stdenv,
  meson,
  ninja,
  pkg-config,
  glib,
  libfprint,
  polkit,
  dbus,
  systemd,
  pam,
  libpam-wrapper,
  pam-fprint-grosshack-src,
  ...
}:
stdenv.mkDerivation {
  name = "pam-fprint-grosshack";
  version = pam-fprint-grosshack-src.shortRev;

  src = pam-fprint-grosshack-src;

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
