pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:74c7cddafcf4c8cadad1317f043cd7ed9f675617197051d38812b262a7afd82b";
  sha256 = "1ify93xr6vcphbflrh654vy8z8937v0qmhfnfn1fidzjg4774zar";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
