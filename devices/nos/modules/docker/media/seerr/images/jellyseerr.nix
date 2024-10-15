pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:319b09a7db75d697bedc41f6784efd47b8f213a26819d636dec2050efe816567";
  sha256 = "1c1g70kycqk97ia6nqws44d6paw6k70xh5dxmmqh0hmizzdhlbvi";
  finalImageName = imageName;
  finalImageTag = "latest";
}
