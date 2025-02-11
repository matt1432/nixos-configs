{
  callPackage,
  gpu-screen-recorder-src,
  ...
}:
callPackage ./generic.nix {
  pname = "gsr-kms-server";
  isKmsServer = true;
  inherit gpu-screen-recorder-src;
}
