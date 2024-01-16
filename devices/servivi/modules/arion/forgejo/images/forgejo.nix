pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:d2c67e2fb33d1d37318abac753b6ab3234415250cfb326427de9354858e97773";
  sha256 = "1375yw3cv46czxf2zdmnxwp222mz44j7kxmv7szbz379smghlf49";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "1.21.4-0";
}
