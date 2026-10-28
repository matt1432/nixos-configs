pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:600f7cd45e27aa13e9304c834ab7c1b0ff39df85ee1dcc5087955455d77bc83b";
  hash = "sha256-Q1hOn2hwPC8NO5o7uRZEv7yVCZ+xcnr/W0KgCY0U/7c=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
