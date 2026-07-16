pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:eda2e378442d2f18cfa563994f8ad66e71f04ac9c3bb4259cc57bdd641890f5c";
  hash = "sha256-Tu2bRfLk91+0IPOK1rTa6fjVXuywiOWwTkrAWPi/RWs=";
  finalImageName = imageName;
  finalImageTag = "15";
}
