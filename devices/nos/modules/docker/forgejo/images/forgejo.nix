pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:3c34f11fe8b9983096eef3f8f25c2d2c21c4ae7504960cb203f0b075d1d8ed73";
  hash = "sha256-pUao0O0BMMGLfH+h7Pqs0RuoarP8zQOH3/JMif1D7RA=";
  finalImageName = imageName;
  finalImageTag = "9";
}
