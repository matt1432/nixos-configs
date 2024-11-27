{
  callPackage,
  gpu-screen-recorder-src,
  ...
}:
callPackage ./generic.nix {
  pname = "gpu-screen-recorder";
  inherit gpu-screen-recorder-src;
}
