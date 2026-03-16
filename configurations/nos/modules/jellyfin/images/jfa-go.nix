pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:0860f5ff8b031a17fd7ec5d8f8f058e027fbf9e6b95a069ba5cbabce024da112";
  hash = "sha256-fSY/95vi5nO/XZznv4441H32eG5m5aBJttRSpm3E11k=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
