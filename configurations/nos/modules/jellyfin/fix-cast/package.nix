{
  writers,
  python3Packages,
  ...
}: let
  pname = "jellyfin-actor-processor";
in
  writers.writePython3Bin pname {
    libraries = with python3Packages; [loguru requests];
    doCheck = false;
  } (builtins.readFile ./main.py)
