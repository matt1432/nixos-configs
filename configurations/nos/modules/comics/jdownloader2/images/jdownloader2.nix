pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/jlesage/jdownloader-2";
  imageDigest = "sha256:8b1ed32eabeb134a5894eb9928a1d44ca3029ab96671ad8fe4e843cfe8ae8757";
  hash = "sha256-0gsiFhiItN3PlPhLNwWquLP7GdhzIKVe4BEaGd/WsPI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
