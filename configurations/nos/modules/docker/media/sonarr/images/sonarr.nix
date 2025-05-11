pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:bae1b72ad55cee030a416aaaef1f20eee076e4c1c6d490689904d4609a2cabac";
  hash = "sha256-x5/G+VrJxaLoWEpSStwyOupw3B0PnIedcRQ33k5sm+s=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
