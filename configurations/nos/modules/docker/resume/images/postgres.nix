pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:06cad38a5d9f5d24b4d83d86def30795d5e4b757fedbf5281172b576dedcd941";
  hash = "sha256-zjIfhJ3lsMnNyWNrHtQpRG6Mi6SxNcwIVvhTMpz9qNI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
