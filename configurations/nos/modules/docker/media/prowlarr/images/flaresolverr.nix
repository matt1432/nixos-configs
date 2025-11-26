pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/flaresolverr/flaresolverr";
  imageDigest = "sha256:4f4e5f759aa3a9a64305e99188ea1db1ec2944a5e7d290d2b089af5f2f6f48e4";
  hash = "sha256-YOCqzmOXoE45gX5DAMcXKSE6bvVflOSItypkknIr7T8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
