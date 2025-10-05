{
  mkShell,
  ocamlPackages,
  ...
}:
mkShell {
  packages = [
    ocamlPackages.ocaml-lsp
    ocamlPackages.ocamlformat
  ];
}
