pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:9a4a7ed79dee5fcc9940b57ddfddfe7c87dea2d13a221ca2fdd2c1c8d9e75c2e";
  hash = "sha256-qWkmwf2RVIn/T/vy2YyJGIR8yc206AoJECkPcEtIWEE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
