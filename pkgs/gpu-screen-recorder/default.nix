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

    postPatch = ''
      # don't try to setcap/suid in a nix builder
      substituteInPlace ./meson.build --replace \
        "meson.add_install_script('extra/meson_post_install.sh')" \
        "# meson.add_install_script('extra/meson_post_install.sh')"
    '';

    fixupPhase = ''
      wrapProgram $out/bin/gpu-screen-recorder \
        --prefix LD_LIBRARY_PATH : "${
        makeLibraryPath [
          addOpenGLRunpath.driverLink
          libglvnd
        ]
      }"
    '';
  }
