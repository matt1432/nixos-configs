pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:a26d06e6878f114ab53aace021fd9c599b498cca4c5ba2c18b34aee472f20148";
  hash = "sha256-T0QRxcZAvwA6LFXkibXfQ12i/9ondXpc9LGICM+7Z6A=";
  finalImageName = imageName;
  finalImageTag = "14";
}
