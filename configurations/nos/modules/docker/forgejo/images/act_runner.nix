pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:8f0a2a19abc102ecb228e75372d14166f65eada4181f4044fbd62e28b79bc3db";
  hash = "sha256-XGqJvJBE4GwDorhA7bZdXh4sav3+vyV+Gb3t5Om3JfA=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
