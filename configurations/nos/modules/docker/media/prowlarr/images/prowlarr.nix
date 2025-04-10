pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:af8eaaa96684a4d83c73684a39ef0abcdc3ee2c0e9ba7b4c90b1523d28327b04";
  hash = "sha256-PYw7cfnTBJVHY3SeHQv3jEF93HXSb//bRBwAW1lUGAA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
