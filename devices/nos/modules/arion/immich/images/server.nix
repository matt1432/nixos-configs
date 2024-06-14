pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:d39cb7ecbcc9924f2c51a3e0deb8a469075996c6ba9e1384eb2ddb550984848e";
  sha256 = "0ynfw50bga8av98mbnnznm9ih3lar9xim7njby8vwbs455iiz6g4";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.106.4";
}
