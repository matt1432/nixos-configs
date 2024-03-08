pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:7e1a43b58abaac59c4b174d17bcdb5072cc1b36a9d892eb03a5672aed6e0c66e";
  sha256 = "1ahi4f9ky8893161jwn4mansxx5ysnq4kbinb8jpi8dnxsshj2j4";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.98.0";
}
