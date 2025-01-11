pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:a134652b47278edfdac3187d61558e78679be39c810536193a41e9e0d894c5f4";
  hash = "sha256-GJXMjY1/wiXldnUB8iNZ0YzQoyqTNPSRqDq7CpsCwiQ=";
  finalImageName = imageName;
  finalImageTag = "release";
}
