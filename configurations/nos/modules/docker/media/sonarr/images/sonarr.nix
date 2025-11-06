pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:4b8a853b76337cd5de5f69961e23b7d0792ce7bf0a8be083dd7202ef670bfc34";
  hash = "sha256-7X+JyAXoO5woO7Cjm9TqqfHbK4OSAq29lAa89IFdfNs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
