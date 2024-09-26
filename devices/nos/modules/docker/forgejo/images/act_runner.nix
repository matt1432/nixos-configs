pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:c265e8cc15e287ca7bef81a1f31e400c6b7c69e787e12d050b8556286a9b6c2e";
  sha256 = "12vm98m2c2gpiqz8ibmk8jq4gl91jbajs91wwraj4vaaz6ji98lj";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
