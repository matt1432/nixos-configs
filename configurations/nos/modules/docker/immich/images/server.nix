pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:b434cb9287eea1471c9974845914d4dd328c9c2d652e446ed4930f99944f0ceb";
  hash = "sha256-T//AeGTrlqECmPJJkP0ZtCsvCjd9r/mN17VhYiCj66g=";
  finalImageName = imageName;
  finalImageTag = "release";
}
