pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:ba2693dd704b84eb0b404d40b3902bd3e62a1768dc5ee0d89b1f1d7cd51a66eb";
  hash = "sha256-Sk0c7gRoX5YL1IbKO9liOod6v9JayVf5fGTtSYzAzIo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
