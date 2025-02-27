pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:7cf23e8d1376d8c56b0d98696762bdecbe3c8b0d3c182592ed66e2e65b4f8f51";
  hash = "sha256-+P4+cviTSxIMlms+uGuKbAhnEpX1qQ143fxmv+NNl/w=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
