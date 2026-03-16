pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:057909965699fd5e28db9babd50173163807a1733acf75e90f5d58aaf2b341a1";
  hash = "sha256-bc+ZKvnev7AdNcqVTJlfKh0eBiLHbU4OmnkEUDdKlF4=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
