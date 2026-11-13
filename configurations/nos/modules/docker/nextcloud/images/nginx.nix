pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:165ddde8751e75a1c907d24ef10d9f6deb08b57e0fe56caf67512486aff76d82";
  hash = "sha256-9wfrLeTV4z2eENphsexoz/MrZvq4XK9TwIPKt5FsUbI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
