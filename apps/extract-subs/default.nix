{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-x4xfn5NiIfNwL0NSHX5j4hj3g1N/Lv5qhgaKMCcu7x0=";

  runtimeInputs = [
    ffmpeg-full
  ];
}
