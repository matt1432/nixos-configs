pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:7a0aa23c0947be3582898deb5170ea4359493ed9a76af2badf60a7eb45ac36af";
  hash = "sha256-jVM6M9MYfGlfe7Qkoec73fwmQEMcJ1BuepQY6UjGaGo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
