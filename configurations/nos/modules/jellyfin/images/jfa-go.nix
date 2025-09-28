pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:6dc4a40ff790c2aeb058b2a24aa06786b009210795733eba76648787af664e1c";
  hash = "sha256-CAmk2Ds8qjiXIZIkkJllIvPVoK7L30U0FjMmfUWu0k8=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
