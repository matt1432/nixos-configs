pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:5af962ae633e97c8e008e4b6e638798de1420e8a9e8e6189beb108a52c6e942a";
  hash = "sha256-o+N54xwZ42PGC4Krc+AoRDthNBhgYYHGRQPEqHTai6w=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
