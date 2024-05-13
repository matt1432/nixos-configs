pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:e8903b7111428b75bf06e066f0e3bfcf4da7271ff6051565c3f97cba46ef7960";
  sha256 = "1w8b3ncdkjpilaifpsmyam852r3chc4xjnzm17byc1b3a4pv521v";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
