pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/postgres";
  imageDigest = "sha256:f36625fffae9611b0e6e28cc1a9bb573d20a9d3cc5e62ab0ff1a19874e34e1f4";
  hash = "sha256-S6P+/lL41lrNkwPVndp6gZZzaNysAIMmjTI/YbTeGeg=";
  finalImageName = imageName;
  finalImageTag = "14-vectorchord0.3.0-pgvectors0.2.0";
}
