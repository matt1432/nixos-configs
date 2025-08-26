pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/postgres";
  imageDigest = "sha256:acbda0b0ee99f84b376c8d41e1346fcd62695a716e88bc44fc1a1334b2693989";
  hash = "sha256-1jdiQUpZa1SQOw2Dbsl8wv+ATA6miRyCOv4JF5o69VM=";
  finalImageName = imageName;
  finalImageTag = "14-vectorchord0.3.0-pgvectors0.2.0";
}
