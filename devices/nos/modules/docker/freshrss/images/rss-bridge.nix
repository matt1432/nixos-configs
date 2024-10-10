pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:c4fd6ad6e395310cc5d49665bfca638d09ba6cf9d03ad60a5c36361cb7c05251";
  sha256 = "1vicsdlyr103qxp1hnwa30qq25k7vi1m4p4hvb1sran1qd7hcas3";
  finalImageName = imageName;
  finalImageTag = "latest";
}
