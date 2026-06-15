pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:d462928b1898dd74b749ef486797968828c1e7fc9befb5e5ca03a33bfbc32d64";
  hash = "sha256-Ua53eedHG83hQJuiyVw5W/XUCJTO7D69/IOLoPk8bik=";
  finalImageName = imageName;
  finalImageTag = "14";
}
