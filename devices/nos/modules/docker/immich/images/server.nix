pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:ac9fb82f2be3cc60d4e0c7f1ceb371d401d52573e387834d7a82776116458242";
  sha256 = "08my8d66fq8pmg5kwjj9v85dnwv53sslsa6hbcvbpwg5pxbnmm52";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "release";
}
