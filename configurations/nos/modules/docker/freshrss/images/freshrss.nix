pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:31b0acfcb8e11600aa6ce697ff8d9d7ea620c85d766e5e764f487b433d20d066";
  hash = "sha256-uUwrpwoSPJbYixdvcqhYO1G9rnCSi7YfFiIWP/biq08=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
