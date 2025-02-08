pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:20b81f5054d31f0151be3c5e282a85361cc24b7ffaab67a997bb4379caa8485b";
  hash = "sha256-3OTC4EDZlZw0zWbhKDm29oBHfr3CZlho7SJ+o+wL+xY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
