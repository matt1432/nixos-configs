pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:fc973eb97c9fd04bfa1840e0f510719a584ccb3be8debfe6a4144637a9dfe8cf";
  hash = "sha256-/6Qurg6VzQ0PGX6d6plYr7jgHvSahkjdamkSkAnLOk0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
