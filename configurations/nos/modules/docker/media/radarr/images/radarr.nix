pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:fe049905ecdfaedf6f37698a3974261c1ef7e5bb165bed6c6d9616c7b9002a88";
  hash = "sha256-LnyHLy+LO4d/gXFT+adCDlyXtvyCf0pX8ky+K+p6xic=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
