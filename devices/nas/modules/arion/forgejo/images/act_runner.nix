pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:e7265566319911566af9b939256d375330c9be49714574e8ee09b704502fda66";
  sha256 = "12x68rykn63gvvm9pmfqnmxllxbckq0m30lwrsfnq46709bl3398";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
