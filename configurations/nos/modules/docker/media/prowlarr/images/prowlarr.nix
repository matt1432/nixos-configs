pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:45117ba8439e2337a92ffe38a451a4dafc0be771754d05d88cdf102419d09646";
  hash = "sha256-XIxa6t6pgKUb19k2IQzsyZM754yw7GDrJ5LHngRCbV4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
