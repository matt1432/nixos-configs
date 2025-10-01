pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:fa81e471a7e46a24b121838563a10d468cf82eecd1587a464c6df4927ecc3248";
  hash = "sha256-w5cDyRDADhLtge7ms02qEqUindjI1U7Jjc22zZyGjI0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
