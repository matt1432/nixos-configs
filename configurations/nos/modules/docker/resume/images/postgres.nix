pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:0cb7397b0ef9c951f642398a24141a61e48168fbc88eeb7b3ad47618e1176ffb";
  hash = "sha256-afFZ6GOyRw6ElVWDc7XIs8y68+685bImXeyWQH7Ylvc=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
