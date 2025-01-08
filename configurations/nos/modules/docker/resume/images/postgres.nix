pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:f85dd74a714c67792c72fc609becff10e0b0eaffca7b40aa1c6251d09c02b5d4";
  hash = "sha256-UOvKUq2TqVLk/KUgugUWWl568ikgj0ck9WV7YWlUqWI=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
