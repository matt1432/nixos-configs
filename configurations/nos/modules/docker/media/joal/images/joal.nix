pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "anthonyraymond/joal";
  imageDigest = "sha256:fc942567c5649b29377e50aa0ca934e4750534d02b4ecf5a0eda3984630f35d7";
  sha256 = "sha256-z/fEL8rYHu8bffND1tv/Nr/pSEHjnMuNekVyL26CCGA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
