pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:954b303893a33b84075857534ad863dc349b8a9e7e838f134e037558ea84823f";
  sha256 = "000iizm8ccyr00mzd1w1ld27b1b9ajxlzajd28k3c6lbjc94ni24";
  finalImageName = imageName;
  finalImageTag = "latest";
}
