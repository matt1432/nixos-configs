{
  # params
  pname,
  description,
  isKmsServer ? false,
  # nix build inputs
  lib,
  stdenv,
  addDriverRunpath,
  makeWrapper,
  gpu-screen-recorder-src,
  # deps
  dbus,
  ffmpeg,
  libdrm,
  libglvnd,
  libpulseaudio,
  libva,
  meson,
  ninja,
  pipewire,
  pkg-config,
  vulkan-headers,
  wayland,
  wayland-scanner,
  xorg,
  ...
}: let
  inherit (lib) makeLibraryPath optionalString;
  inherit (builtins) fromTOML readFile;

  tag =
    (fromTOML (readFile "${gpu-screen-recorder-src}/project.conf"))
    .package
    .version;
in
  stdenv.mkDerivation {
    inherit pname;
    version = "${tag}+${gpu-screen-recorder-src.shortRev}";

    src = gpu-screen-recorder-src;

    # Get rid of useless warning due to how I install the package
    postPatch = ''
      sed -i 's/.*gsr-kms-server is not installed in the same directory.*//' ./kms/client/kms_client.c
    '';

    nativeBuildInputs = [
      makeWrapper
      meson
      ninja
      pkg-config
    ];

    buildInputs = [
      dbus
      ffmpeg
      libdrm
      libpulseaudio
      libva
      pipewire
      vulkan-headers
      wayland
      wayland-scanner
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXi
      xorg.libXrandr
    ];

    mesonFlags = [
      "-Dcapabilities=false"
      "-Dnvidia_suspend_fix=false"
      "-Dsystemd=false"
    ];

    fixupPhase =
      optionalString (!isKmsServer)
      # bash
      ''
        runHook preFixup

        wrapProgram $out/bin/gpu-screen-recorder \
          --prefix LD_LIBRARY_PATH : "${
          makeLibraryPath [
            addDriverRunpath.driverLink
            libglvnd
          ]
        }"

        runHook postFixup
      '';

    # This is needed to force gsr to lookup kms in PATH
    # to get the security wrapper
    postFixup =
      if isKmsServer
      then
        # bash
        ''
          rm $out/bin/gpu-screen-recorder
        ''
      else
        # bash
        ''
          rm $out/bin/gsr-kms-server
        '';

    meta = {
      mainProgram = pname;
      license = lib.licenses.gpl3Only;
      platforms = ["x86_64-linux"];
      homepage = "https://git.dec05eba.com/gpu-screen-recorder/about";
      inherit description;
    };
  }
