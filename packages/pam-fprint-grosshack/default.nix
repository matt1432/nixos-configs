{
  # nix build inputs
  lib,
  stdenv,
  pam-fprint-grosshack-src,
  # deps
  dbus,
  glib,
  libfprint,
  libpam-wrapper,
  meson,
  ninja,
  pam,
  pkg-config,
  polkit,
  systemd,
  ...
}: let
  inherit (builtins) elemAt head readFile split;
  tag = head (split "'" (elemAt (split " version: '" (readFile "${pam-fprint-grosshack-src}/meson.build")) 2));
in
  stdenv.mkDerivation {
    pname = "pam-fprint-grosshack";
    version = "${tag}+${pam-fprint-grosshack-src.shortRev}";

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

    meta = {
      license = with lib.licenses; [gpl2Plus];
      homepage = "https://gitlab.com/mishakmak/pam-fprint-grosshack";
      description = ''
        This is a fork of the pam module which implements the simultaneous password and
        fingerprint behaviour present in pam_thinkfinger.
      '';
    };
  }
