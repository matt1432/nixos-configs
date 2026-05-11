pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:15417a594ebda4c660a9fa9748e7199d33e2d17b31bbc5ad7ba2e86f0b414763";
  hash = "sha256-vN/4MtnFfXIKc1cU6+/Iumv/IXb4RI6cmgKLy28qG2c=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
