pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:14ad5881f5afbea1dbf751e14acaafe00e6b012ffb18a56e9f117b00eb067d1d";
  sha256 = "0wxdcag6bhbzcxmbygw4qmh9j3h32yhgh93d0fy33xh6j3akjkyb";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.111.0";
}
