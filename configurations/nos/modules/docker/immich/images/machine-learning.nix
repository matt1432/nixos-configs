pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:590a76bba3d88ccf78b03cde0c0fb8788f7d76ae6caf90ad33a34b5b4cc35f11";
  hash = "sha256-tfBw2Rlm7EhKu6Vr+TtBa5cgU0IEekyr+TsPbWsRnNw=";
  finalImageName = imageName;
  finalImageTag = "release";
}
