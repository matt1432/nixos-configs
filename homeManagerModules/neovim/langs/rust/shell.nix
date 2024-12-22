{
  mkShell,
  cargo,
  rustc,
  rust-analyzer,
  rustfmt,
  ...
}:
mkShell {
  packages = [
    cargo
    rustc
    rust-analyzer
    rustfmt
  ];
}
