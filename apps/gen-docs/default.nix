{
  writeShellApplication,
  jq,
  pandoc,
  ...
}:
writeShellApplication {
  name = "gen-docs";
  runtimeInputs = [jq pandoc];
  text = builtins.readFile ./script.sh;
}
