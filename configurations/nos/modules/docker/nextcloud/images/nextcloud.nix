pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:d6e30ce91a6c34c18c0822f83c4a16e90da750e04fd5f521ecf73ef580c0d59b";
  hash = "sha256-ib+N6Gc/8L5LOlINou+A1MT6842tDBrcH4tjUPp4jXQ=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
