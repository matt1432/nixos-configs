pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:40d0756a47199d7fa8d6a4a72e555f79ee760dbaf3cae199c7eb21d766785d9b";
  sha256 = "1sjmsc5k916h6m09f53z401qvnc0w3lqm88s5ics4hh8h428vcx5";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.0-fpm";
}
