{
  mkShell,
  bumpNpmDeps,
  nodejs_latest,
  typescript,
  ...
}:
mkShell {
  packages = [
    bumpNpmDeps
    nodejs_latest
    typescript
  ];
}
