{
  callPackage,
  gpu-screen-recorder-src,
  ...
}:
callPackage ./generic.nix {
  pname = "gsr-dbus-server";
  inherit gpu-screen-recorder-src;

  description = ''
    Small program to move dbus code to a separate process to allow gpu-screen-recorder to
    use cap_sys_nice for better recording performance on AMD.
  '';
}
