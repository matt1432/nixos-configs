pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:24acea2956a0ccb11f103877d9f4f8576600fb34bff34820ed749c2256dab89f";
  hash = "sha256-zU4q0qaFkHXY3eNSnhGtejzJagxjC12L1NU8bSBFP1Q=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
