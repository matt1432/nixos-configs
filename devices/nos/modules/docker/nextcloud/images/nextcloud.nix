pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:57387ca28bbbbc1fb2e7305a4750c28354f5f6ecf7201fef2af50c144f75f6f3";
  sha256 = "01vsrmjriadpxx27hwr71z7r3cfb6l592srbi0mhsxzbjc64zmm4";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
