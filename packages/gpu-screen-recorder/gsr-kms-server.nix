{
  callPackage,
  gpu-screen-recorder-src,
  ...
}:
callPackage ./generic.nix {
  pname = "gsr-kms-server";
  inherit gpu-screen-recorder-src;
}
