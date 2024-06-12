{
  addOpenGLRunpath,
  stdenv,
  ffmpeg,
  gpu-screen-recorder-src,
  lib,
  libdrm,
  libglvnd,
  libpulseaudio,
  libva,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
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
    name = "gpu-screen-recorder";
    version = "${tag}+${gpu-screen-recorder-src.shortRev}";

    src = gpu-screen-recorder-src;

    nativeBuildInputs = [
      pkg-config
      makeWrapper
      meson
      ninja
    ];

    buildInputs = [
      libpulseaudio
      ffmpeg
      wayland
      libdrm
      libva
      xorg.libXcomposite
      xorg.libXrandr
    ];

    mesonFlags = ["-Dcapabilities=false"];

    fixupPhase = ''
      wrapProgram $out/bin/gpu-screen-recorder \
        --prefix LD_LIBRARY_PATH : "${
        makeLibraryPath [
          addOpenGLRunpath.driverLink
          libglvnd
        ]
      }"
    '';

    meta = {
      description = "Screen recorder that has minimal impact on system performance by recording a window using the GPU only";
      homepage = "https://git.dec05eba.com/gpu-screen-recorder/about/";
      license = lib.licenses.gpl3Only;
      platforms = ["x86_64-linux"];
    };
  }
