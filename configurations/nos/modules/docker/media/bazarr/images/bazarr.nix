pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:4c30dc0bb9a5d223075e7f5d12c77bd293c4b460f86d696dbe64763104c1e88c";
  hash = "sha256-UsYkVqCYliszY2Lu6omTXeBH+0xy+Jm2gLo+BeF9HY0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
