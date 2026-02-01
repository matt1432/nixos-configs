pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:4327b9fd295502f326f44153a1045a7170ddbfffed1c3829798328556cfd09e2";
  hash = "sha256-BzZBnm2x55M/QOXWo/ZAYgynbpUlyPdHcWL0rqW8hVQ=";
  finalImageName = imageName;
  finalImageTag = "16-alpine";
}
