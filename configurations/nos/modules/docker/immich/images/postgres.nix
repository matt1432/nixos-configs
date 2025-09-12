pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/postgres";
  imageDigest = "sha256:141283a73bcc69a732b9f83de783a52a880eb6f8a423fe8a216505c81ad56bf8";
  hash = "sha256-bCo+P4FOjk17hFi0uIxbSfkY1gn5D5FV5X3hx12N3OM=";
  finalImageName = imageName;
  finalImageTag = "14-vectorchord0.3.0-pgvectors0.2.0";
}
