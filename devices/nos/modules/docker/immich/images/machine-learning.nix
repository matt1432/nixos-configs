pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:f7964140e00bd615497d37040eb907a7cd87db6f06baea784d411cda572a29df";
  sha256 = "0d4kq4png0dg0xm4ch1zri56mcqvb05xn2sgai47ihql1r0rm315";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.113.0";
}
