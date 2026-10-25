{
  writeShellApplication,
  gawk,
  hostname,
  jq,
  ...
}:
writeShellApplication {
  name = "eval-warnings";
  runtimeInputs = [gawk hostname jq];
  text = builtins.readFile ./script.sh;

  meta.description = ''
    Forces a fresh evaluation of derivations, bypassing the eval cache, and prints every warning and trace they produce.
  '';
}
