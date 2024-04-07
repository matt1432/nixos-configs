pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:182a82bbbe36d37e5450975549628455a833d50b896cf670967d79eac1ede293";
  sha256 = "1ar8yx2gh3x8mrmwnqlmj15nnx27kyrn6vxdpkm9j4l4hzppx2y3";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}
