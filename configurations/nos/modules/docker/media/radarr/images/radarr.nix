pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:7b45af3b660f5ff5f7d6d625bfa99960cb9265e902f1bef136486f6d2be73ee9";
  hash = "sha256-1jJD05FqSppX11RfLOMlplk2oATxiMeb5DkJl4p6l5s=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
