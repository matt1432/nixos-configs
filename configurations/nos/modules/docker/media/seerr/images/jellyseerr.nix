pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:2a611369ad1d0d501c2d051fc89b6246ff081fb4a30879fdc75642cf6a37b1a6";
  hash = "sha256-9bl7VECU2oI/tHLuyOWUoTDz7KrrBX5s5AXZ7p0OB+w=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
