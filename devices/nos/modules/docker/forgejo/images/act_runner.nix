pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:f7e6d2e86588d36b371b71f80356de04e774bba12c45b2246ea02020412b2cbf";
  sha256 = "1vwqry7j1dj4swd1336a8lhc357svq4axfj56d199nhf2yvzdzyb";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
