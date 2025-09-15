pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:19474a623b278f558c9696a19b84640ad4aff3b2959f08904a77ffbad73ed7bd";
  hash = "sha256-KxI7rIZ63P+d+0RByd8RjxumNuguVZ59njpUfef7usY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
