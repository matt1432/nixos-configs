{
  # Params
  pname,
  gpu-screen-recorder-src,
  isKmsServer ? false,
  # Derivation deps
  lib,
  addDriverRunpath,
  dbus,
  ffmpeg,
  libdrm,
  libglvnd,
  libpulseaudio,
  libva,
  makeWrapper,
  meson,
  ninja,
  pipewire,
  pkg-config,
  stdenv,
  vulkan-headers,
  wayland,
  xorg,
  ...
}: let
  inherit (lib) makeLibraryPath;
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

    # Get rid of useless warning
    postPatch = ''
      sed -i 's/.*gsr-kms-server is not installed in the same directory.*//' ./kms/client/kms_client.c
    '';

    nativeBuildInputs = [
      pkg-config
      makeWrapper
      meson
      ninja
    ];

    buildInputs = [
      dbus
      libpulseaudio
      pipewire
      ffmpeg
      wayland
      libdrm
      libva
      vulkan-headers
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

    fixupPhase = ''
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
          rm $out/bin/.gpu-screen-recorder-wrapped
        ''
      else
        # bash
        ''
          rm $out/bin/gsr-kms-server
        '';

    meta = {
      description = "Screen recorder that has minimal impact on system performance by recording a window using the GPU only";
      homepage = "https://git.dec05eba.com/gpu-screen-recorder/about/";
      license = lib.licenses.gpl3Only;
      platforms = ["x86_64-linux"];
      mainProgram = pname;
    };
  }
