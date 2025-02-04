pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:bc2f6a7c8ddbccf55bdb19659ce3b0a92ca6559e86d42677a5a02ef6bda2fcef";
  hash = "sha256-ph+Q+mh2IB5IRm8O1X2dxrx+Qk/LJjAGN38oa7AcXqg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
