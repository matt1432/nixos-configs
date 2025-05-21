pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/postgres";
  imageDigest = "sha256:b5e2fcf89f01effa82f1a8c3415a680d5df3d90318f70d05ea7db7170934a659";
  hash = "sha256-rR9M4IIxAJ2cS35DBqaE1jBSbTobeR8uq7LJMBtyN+g=";
  finalImageName = imageName;
  finalImageTag = "14-vectorchord0.3.0-pgvectors0.2.0";
}
