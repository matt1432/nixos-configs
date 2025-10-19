pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:5c5f76b68d151a9a531cf4c8dcfaf7fc4b25f1fbbdabc7324b67c58d7812feca";
  hash = "sha256-9kwnu8suUCemyQCWCls565NJDKXvPJiBKg6E7j4JFYE=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
