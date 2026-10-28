pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:0472f5295d05c211cc42b3daa5e84a128e390c5267b60ced9fe044bcf4edfdb8";
  hash = "sha256-T0QRxcZAvwA6LFXkibXfQ12i/9ondXpc9LGICM+7Z6A=";
  finalImageName = imageName;
  finalImageTag = "14";
}
