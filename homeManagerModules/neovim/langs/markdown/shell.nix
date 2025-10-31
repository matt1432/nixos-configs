{
  mkShell,
  pandoc,
  texlab,
  texliveSmall,
  rubber,
  ...
}:
mkShell {
  packages = [
    pandoc
    texlab
    texliveSmall
    rubber
  ];
}
