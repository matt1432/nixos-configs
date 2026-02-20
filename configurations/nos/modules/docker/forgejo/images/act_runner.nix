pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:025de2c40437a4ae300c590ce5bc76be87fb5eee2241cdc5afd5ac34eb4c0335";
  hash = "sha256-6wMyygxQjb62WvMR7cTrCxaCn4VthnJjZCrcsJ0akds=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
