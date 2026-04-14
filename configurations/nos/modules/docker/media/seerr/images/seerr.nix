pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/seerr-team/seerr";
  imageDigest = "sha256:d535391db3b5a22ce02241e6d7a50ca714e75d927e46aa20456b77fa051cbf52";
  hash = "sha256-+qkoFOVkvlf+SlwfXZct+Smei7VBZup8xLJ2UiHazPk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
