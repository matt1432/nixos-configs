pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:d24a2146c7b0ab87d16d0fd38c0e56247a36e255d9e5e37159fa86aa70e73ffc";
  sha256 = "1gdhz30xfln39anl5gz03fmcc85b3vl61zg472ycpsp6gsqhr2sh";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
