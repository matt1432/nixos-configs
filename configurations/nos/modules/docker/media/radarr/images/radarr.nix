pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:3f6c13cd920e60469e24fac6b25338b0805832e6dea108f8316814d0f4147ab6";
  hash = "sha256-OHBUs8e7HuIofB6dJhzS0pSTs42zkCE+BUBVJ8uOraY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
