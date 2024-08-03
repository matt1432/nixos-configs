{
  cliphist,
  gawk,
  imagemagick,
  ripgrep,
  writeShellApplication,
  ...
}:
writeShellApplication {
  name = "clipboard-manager";
  runtimeInputs = [
    cliphist
    gawk
    imagemagick
    ripgrep
  ];

  text = builtins.readFile ./script.sh;
}
