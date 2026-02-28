pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:4cb83b05d91d6776de74a9f65645aac8838161b27a95ae00c776f58ae53dd111";
  hash = "sha256-5HXOzG5gEAA/xTUigi3Y9wNGQSK/uiPAIAvxO8efYUc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
