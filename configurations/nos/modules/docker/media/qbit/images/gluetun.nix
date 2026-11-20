pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:b87e3bb7e1dec36715ce6c34cd48edc2d75a7c3691229ba65845f3739033a292";
  hash = "sha256-uHgi5xaTW7jw2NlNbWNshgqCFRJCC5M/Sq+6pVyKUx8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
