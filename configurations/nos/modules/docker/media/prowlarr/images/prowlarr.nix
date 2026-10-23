pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:b3b00047ed20f6ce2b16780145cb6a0acb51c9e28ea6aa6f5dcd33c7034f1797";
  hash = "sha256-LbQl2gqk96P3oa+xctm5+cuh7dbqyJ6hjOTLvj9iIe4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
