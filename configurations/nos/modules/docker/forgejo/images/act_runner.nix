pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:91145d2f9f3b3328dee736520d6cbeddd2c10034ade707428d4c20e71a358651";
  hash = "sha256-rzBn/VuJu+Nk5R0ZIWtu8OrnXampIcrbFVpCJJOvzzA=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
