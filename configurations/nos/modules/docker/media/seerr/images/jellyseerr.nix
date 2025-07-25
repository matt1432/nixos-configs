pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:98296861cf3caebe8ada72e5dbe2729fb10cdb2042d2b82e86065bf870418587";
  hash = "sha256-VMmngl61izTvBGvvozyiw3xY36z5b5uPdmCy9LGaZHY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
