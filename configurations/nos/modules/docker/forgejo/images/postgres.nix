pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:fbd63b8e1eb2b318d342e8ad279891f622aa5ff69bd95e5683cc915301218bcf";
  hash = "sha256-ydnS5rIGGWwYQLxrSQk8mo3SI3QqOivJSuSRtkEtCY4=";
  finalImageName = imageName;
  finalImageTag = "14";
}
