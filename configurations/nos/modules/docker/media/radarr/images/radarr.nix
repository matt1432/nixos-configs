pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:a45b5ab0f850f39edb4cc9c95bbd967b52ddc3d4574a4dfb45561177db6c88f4";
  hash = "sha256-/P5TccePsHdCMZfYI9uz4E/pOHBdE8J9lwO2qDBwTJg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
