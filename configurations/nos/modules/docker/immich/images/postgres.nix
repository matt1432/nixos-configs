pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/postgres";
  imageDigest = "sha256:9d1c54201c5e122a2fd9df216d945bbb58dca62b7f0aab76107a38850851225f";
  hash = "sha256-GiM3CN2ThIpWTPQCNtxQKLrKU/o/qLv/Oq2wg1H0iFE=";
  finalImageName = imageName;
  finalImageTag = "14-vectorchord0.3.0-pgvectors0.2.0";
}
