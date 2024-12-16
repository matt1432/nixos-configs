pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:a9b4375f73c01e594ff4c7317232384e688856969afeb7d9050aa06447ef6f86";
  hash = "sha256-gZXJvKfYx92kIWcxeSklP7yZihyPamF/BafADR1/CrQ=";
  finalImageName = imageName;
  finalImageTag = "release";
}
