pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:05f9d5b24884f37120453dc1a008a47be244eebec32099ae1bd29032e75b67aa";
  hash = "sha256-A0WQMmovuzt3uDVs8yEgDZmRszuuzR9TFJBXK3kMnrg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
