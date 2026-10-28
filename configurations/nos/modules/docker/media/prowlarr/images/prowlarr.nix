pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:04be30163fbaf48d6aeee7b5893c9f6614ffbad6d853971df0d6dcdf01c7f104";
  hash = "sha256-cjdp/rUb01uSLu3UdRYaAQmAul33AxWYD3osQl4mJeg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
