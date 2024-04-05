pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:167ae839ce5068f83617f698f7565b174c57643372de4dcce69e2d030e19684d";
  sha256 = "1yh2nc6zh6aac8hs0hjl248xyhddq515xw5vaflcm09n301hbj5n";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}
