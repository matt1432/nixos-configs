pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:198d52734136fe9840866cc2f48a8141e0d002c2a25be7e35cd28ef7936b6c67";
  hash = "sha256-G3QgUH4/mKJiudZ5SdnWP7FMlkBqf4U+X9JV+8VMvTk=";
  finalImageName = imageName;
  finalImageTag = "release";
}
