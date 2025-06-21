pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:3ec2ce92445719ea1e610b3e758da20cd317c8e1028fc810d001b1370a339226";
  hash = "sha256-fzEfL+c6lAcv3PwTl9KI20L525MyrcyANDvWSnibyTk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
