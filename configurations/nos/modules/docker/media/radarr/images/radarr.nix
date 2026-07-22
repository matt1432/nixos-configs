pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:e35056574cdc695a9ee745aa1ecda9eab3842450bf4b7b8471b023790fa3861d";
  hash = "sha256-BBJjFV2bDpLqJ8yy1Afx23mbPt2MCNfLGAD/uY7rq6E=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
