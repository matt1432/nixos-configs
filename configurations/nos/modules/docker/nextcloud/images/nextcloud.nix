pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:3d017f226daa668be007c1f57741f24453203719e24231adb30b57461a55de46";
  hash = "sha256-rsP6LJdnDV2m9vVjwMSpefOREMEnOaPmZ61RZVqWi7k=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
