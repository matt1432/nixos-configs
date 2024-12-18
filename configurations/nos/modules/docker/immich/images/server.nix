pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:666ce77995230ff7327da5d285c861895576977237de08564e3c3ddf842877eb";
  hash = "sha256-whUt1aZuvJv5HewqJ6WFWnnHdKy7pstyXzZsspJgg2A=";
  finalImageName = imageName;
  finalImageTag = "release";
}
