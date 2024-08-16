pkgs:
pkgs.dockerTools.pullImage {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:d9437b6d8455de45a02dd5ed2529c8c19c5d1407076c03ca73e0737941ec3748";
  sha256 = "04kaf0n5b55vvcwwrna7icn9xfx03viri8yr085hkydb40871qpz";
  finalImageName = "onlyoffice/documentserver";
  finalImageTag = "latest";
}
