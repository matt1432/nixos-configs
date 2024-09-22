pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:724553f742322d67f34282be46b414572d4e0cd46ccd54d2f2a24b6a87a472b0";
  sha256 = "042an85vz29gb8ipd3sprnslhly3v1zz0qiib2dyibgq1f82qz3q";
  finalImageName = "nextcloud";
  finalImageTag = "fpm";
}
