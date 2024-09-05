pkgs:
pkgs.dockerTools.pullImage {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:a69b1c43c6641e45789a6ebb7e84359ada749c8e2d4e83916d4e85945238f418";
  sha256 = "112cd832rw6ggs4wc7dg4abd4wal8xphysy7l1hd6hnlr5ganz79";
  finalImageName = "onlyoffice/documentserver";
  finalImageTag = "latest";
}
