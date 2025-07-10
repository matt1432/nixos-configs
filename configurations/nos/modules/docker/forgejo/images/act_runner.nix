pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:e5d8940741a7966caf371ec19b222f104cb74bb2bdbb142bb2fcfc5329f1eecb";
  hash = "sha256-Tdz9T4CHzU+DJHZD2Ewxuyi+x5any1xa7IUjbIHA0Us=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
