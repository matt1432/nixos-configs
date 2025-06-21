pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/postgres";
  imageDigest = "sha256:007a98749340534a0408a26435b1a0ab5ded76df788f897fdb6342c9c1b95448";
  hash = "sha256-jHSwaHXbT4/PrlLcxs8hetcZK68frez1nClDIaolDS8=";
  finalImageName = imageName;
  finalImageTag = "14-vectorchord0.3.0-pgvectors0.2.0";
}
