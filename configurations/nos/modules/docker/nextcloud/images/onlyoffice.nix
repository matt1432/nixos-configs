pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:3489a54c581414055dd9bfa3890435e5e6fc8c4ce0ffdd65cf3c7869f680cf81";
  sha256 = "1m0mjgx7lwvcsxx8aaznardpc87hs3874vsll7hplldhg9q80j5h";
  finalImageName = imageName;
  finalImageTag = "latest";
}
