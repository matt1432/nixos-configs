pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:ec4ed8b5299e5e90694af7750eb6dffd2627317d30544d056b0371f8082f7bce";
  hash = "sha256-HxOQUpdWrvOViFX4JPWD/A3aGw+uVlR68bvF39gDMfo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
