pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:42b4d1d1e3fb2c361a3a2fe2921a847bbdcd0d6d14a4d411482665fc4560a58d";
  sha256 = "0f0d0710k99gq4dvayjl4n0aby8gly04jp9bn6qab0j3zy0wdb0y";
  finalImageName = imageName;
  finalImageTag = "latest";
}
