pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:3ab8e332004c693421320ac7e22065a1187f3d0e84255f97cacf83bce7bdfc1f";
  sha256 = "05i9ik4y3zn71wybbaahd2zsgnkswwzxr1na8l16jn2ncbacggrh";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.109.2";
}
