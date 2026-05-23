pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:4ad626da7e1d2774ca51bbfa812f832d5639264b3fe308909e47de02ba2188f7";
  hash = "sha256-VHKwfn8iWTc7Ml/1780ztL6wF9u2R2/PMXELuPOf1jo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
