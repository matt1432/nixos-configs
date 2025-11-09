{
  mkShell,
  bumpNpmDeps,
  ffmpeg-full,
  nodejs_latest,
  typescript,
  ...
}:
mkShell {
  packages = [
    nodejs_latest
    typescript
    ffmpeg-full

    bumpNpmDeps
  ];

  meta.description = ''
    Shell that provides the dependencies for my subtitle management scripts.
  '';
}
