pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:a45c76bad7a7cdc9b6d034409f1dabc23cc6bd3e6bb3ce62866eda1f9c10d114";
  sha256 = "0n077ihjj6zgkp7h7g1y71g0qkagykiq46hl9kwjnc6m2fgzlfmm";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
