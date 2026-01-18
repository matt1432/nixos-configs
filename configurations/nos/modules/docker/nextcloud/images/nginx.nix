pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:c881927c4077710ac4b1da63b83aa163937fb47457950c267d92f7e4dedf4aec";
  hash = "sha256-TMGD33oya+VQLkNLdhLUTLbWNI73JoFKs5+hy0vE3SE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
