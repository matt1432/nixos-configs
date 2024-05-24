pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:2be0978c416b10534b8b6753f10571ba3da4c88260671488780103862d3c76c1";
  sha256 = "1d5ka604fl2bwqgv4id9773a7fsvlfmgfq3x7pbbrzdbcwxy1541";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
