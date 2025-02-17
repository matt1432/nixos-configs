{
  # nix build inputs
  lib,
  stdenv,
  fetchFromGitLab,
  nix-update-script,
  # deps
  dbus,
  glib,
  libfprint,
  libpam-wrapper,
  libxml2,
  libxslt,
  meson,
  ninja,
  pam,
  perl,
  pkg-config,
  polkit,
  python3Packages,
  systemd,
  ...
}: let
  pname = "pam-fprint-grosshack";
  version = "0.3.0";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitLab {
      owner = "mishakmak";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-obczZbf/oH4xGaVvp3y3ZyDdYhZnxlCWvL0irgEYIi0=";
    };

    # Tests aren't actually ran for some reason so I get rid of the warning
    postPatch = ''
      substituteInPlace ./meson.build --replace-fail \
          "'gi.repository.FPrint': true," "'gi.repository.FPrint': false,"
    '';

    nativeBuildInputs = [
      dbus
      glib
      libfprint
      libpam-wrapper
      libxml2
      libxslt
      meson
      ninja
      pam
      perl
      pkg-config
      polkit
      systemd

      python3Packages.python
      python3Packages.dbus-python
      python3Packages.pydbus
      python3Packages.pypamtest
      python3Packages.python-dbusmock
    ];

    mesonFlags = [
      "-Dgtk_doc=true"
      "-Dman=true"
      "-Dpam_modules_dir=${placeholder "out"}/lib/security"
      "-Dsysconfdir=${placeholder "out"}/etc"
      "-Ddbus_service_dir=${placeholder "out"}/share/dbus-1/system-services"
      "-Dsystemd_system_unit_dir=${placeholder "out"}/lib/systemd/system"
    ];

    passthru.updateScript = nix-update-script {
      extraArgs = [
        ''--version=$(curl -s https://gitlab.com/api/v4/projects/mishakmak%2Fpam-fprint-grosshack/repository/tags | jq -r .[0].name)''
      ];
    };

    meta = {
      license = with lib.licenses; [gpl2Plus];
      homepage = "https://gitlab.com/mishakmak/pam-fprint-grosshack";
      description = ''
        This is a fork of the pam module which implements the simultaneous password and
        fingerprint behaviour present in pam_thinkfinger.
      '';
    };
  }
