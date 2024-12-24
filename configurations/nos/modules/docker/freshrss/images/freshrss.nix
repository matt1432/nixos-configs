pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:e7897e90c1e0ab4a68cb643ff509dec4e3b85bbe42e2688ed9f95eb190bcb2b1";
  hash = "sha256-ohNo0vkAle9RWU2XnK/Ye4co7+k11SYjzuw0FthNrzM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
