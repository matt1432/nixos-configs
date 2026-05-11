pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:7e32e9833a6fb1c92c32552794cb6ed569d51b445a54907d35fc112ef39684db";
  hash = "sha256-PQSicCXvKVFAwzquy+H5mFzxAC3V1BCX8dyOLi6lWP4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
