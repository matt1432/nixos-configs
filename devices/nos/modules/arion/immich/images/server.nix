pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:2b9c87617e55e3471a1239b0fa00041361517dd8f65c7db46abc7392c0fb561a";
  sha256 = "1w87knckw19hr32g7ck6zc2nq7m1bpfisihw66bzixp67f2qw0gm";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.107.0";
}
