{
  writeShellApplication,
  pandoc,
  ...
}:
writeShellApplication {
  name = "gen-docs";
  runtimeInputs = [pandoc];
  text = builtins.readFile ./script.sh;
}
