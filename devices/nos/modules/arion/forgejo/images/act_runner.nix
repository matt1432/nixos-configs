pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:ee2cc83a2966ddce47e9aa147122e05dfecc5e390c8738ce33a0cc8f9f7987fc";
  sha256 = "15jgc7fc13ka91bqglnzq6rgxiny723hpv312b8v5vl5cy687gan";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
