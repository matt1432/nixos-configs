{
  callPackage,
  gpu-screen-recorder-src,
  ...
}:
callPackage ./generic.nix {
  pname = "gsr-kms-server";
  inherit gpu-screen-recorder-src;

  description = ''
    Small program giving safe KMS access to gpu-screen-recorder when recording a monitor.
    This is the only part of gpu-screen-recorder that could require root permissions.
  '';
}
