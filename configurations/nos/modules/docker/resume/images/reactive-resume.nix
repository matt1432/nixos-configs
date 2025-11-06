pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "amruthpillai/reactive-resume";
  imageDigest = "sha256:f1b27f567b2a1b57fb6b2a81f7b9cec0af577b6be945820c1599a0a8b6b91f8b";
  hash = "sha256-IE1lYq+4AmQuRVNVJ2Vb1ji5Tw4ILH2hRrwDmVXJp10=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
