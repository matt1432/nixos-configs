pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:6f73bbba33391a338e20d836a60c86beaf2a865a89b706b339fc8cb0b8ce1559";
  hash = "sha256-jd5c2Te8LnNP952wOtByumpAi41VVe3A8Wn7veJCObI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
