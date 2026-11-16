pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:923c2fe435e22fc58d261bacd2d6bbd8eb1ba3f95358803a8e4d3287ffd919d3";
  hash = "sha256-B1kemji55gHWv1B9tigNd3pcdl0eSc7X/BYc2eZqrYc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
