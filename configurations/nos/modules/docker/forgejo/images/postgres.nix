pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:c0e9c0e9bac7e4c1834b698217a03ee5c708de30d313c84a506972de0e24b059";
  hash = "sha256-m1zl1kCndRn/TayS2LpXSEjUvypkcli8FVnL0qH2aKA=";
  finalImageName = imageName;
  finalImageTag = "14";
}
