{
  callPackage,
  gpu-screen-recorder-src,
  ...
}:
callPackage ./generic.nix {
  pname = "gpu-screen-recorder";
  inherit gpu-screen-recorder-src;

  description = ''
    Screen recorder that has minimal impact on system performance by recording
    a window using the GPU only.
  '';
}
