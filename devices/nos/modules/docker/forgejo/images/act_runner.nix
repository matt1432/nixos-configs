pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:674ef43377a9b802d53cbcf97ee128f95dd00cec817fb075950dcf7a618d880c";
  sha256 = "1zd4w4vwij00ixdphv918g2js0ajimxdd43hwycfg4xqazmrvnpi";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
