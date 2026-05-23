pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:c9fe528f34b1fd3715438b6f6d6991d64e2965f2c055db36398bc66a0e7eab01";
  hash = "sha256-xyy4Oczjcqv26YSZbgyyQJDKHBWWIqlF5xL/rBnqnDI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
