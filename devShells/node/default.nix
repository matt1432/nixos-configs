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

  meta.description = ''
    Shell that provides `bumpNpmDeps`, node and typescript.
  '';
}
