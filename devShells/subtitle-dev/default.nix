{
  mkShell,
  bumpNpmDeps,
  ffmpeg-full,
  nodejs_latest,
  nodePackages,
  typescript,
  ...
}:
mkShell {
  packages = [
    nodejs_latest
    typescript
    ffmpeg-full
    nodePackages.ts-node

    bumpNpmDeps
  ];

  meta.description = ''
    Shell that provides the dependencies for my subtitle management scripts.
  '';
}
