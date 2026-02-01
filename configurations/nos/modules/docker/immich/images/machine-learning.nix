pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:531d2bccbe20d0412496e36455715a18d692911eca5e2ee37d32e1e4f50e14bb";
  hash = "sha256-5h3veLEKoDgW6RYSpqfwlVlZ0AUJ8Dm0/VPkAvazrzU=";
  finalImageName = imageName;
  finalImageTag = "release";
}
