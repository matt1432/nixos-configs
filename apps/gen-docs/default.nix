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

  meta.description = ''
    Generates the READMEs in this repository from nix attributes.
  '';
}
