pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/postgres";
  imageDigest = "sha256:34da466322609f184a4f870f704317f1fc1eb71be1f119437f02e5d29d47f346";
  hash = "sha256-i/AvQj+8UZg2FbUlPcPYt1jtcxOhl1Ri5BLyruIy3iA=";
  finalImageName = imageName;
  finalImageTag = "14-vectorchord0.3.0-pgvectors0.2.0";
}
