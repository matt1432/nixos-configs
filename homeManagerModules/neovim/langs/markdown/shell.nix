{
  mkShell,
  pandoc,
  texlab,
  texliveFull,
  rubber,
  ...
}:
mkShell {
  packages = [
    pandoc
    texlab
    texliveFull
    rubber
  ];
}
