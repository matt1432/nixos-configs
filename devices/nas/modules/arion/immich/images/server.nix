pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:bd1558f9bb6a107eb924393e77a96d39a917d63a7f2d3b3055544e2f05444d13";
  sha256 = "0b21m2ssmk0xpxsblb16av938xj14msivrsg2yg87y1gi8nswzl1";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.96.0";
}
