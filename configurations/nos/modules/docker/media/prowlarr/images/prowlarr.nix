pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:81fb4868e9340f807d91a17012e467a274f7bfb86fe31190ad40c0723e2a22c5";
  hash = "sha256-xPu85r68/uNZ5EIht5t+6n2W1iCCnTtIpNzzEXWKIQg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
