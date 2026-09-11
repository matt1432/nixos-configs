pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:f8b2869891c861a58dde969d86e7ea8a186e6059a55886632ee3249e51fb574a";
  hash = "sha256-kLgCWqbDlUSM5UzPn6BSOGr8xN3Yt74oCLSpA4BtoKk=";
  finalImageName = imageName;
  finalImageTag = "release";
}
