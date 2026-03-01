pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:b82feb174aa2ce90768930d49fc181de5a2a980446f398180561057c3658ad61";
  hash = "sha256-DGHrQmEE4uC+qAlP+tBfaHfjSHKiiUzxlGiAjI+J8AM=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
