pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:563b01707cb4509731793ce03bfc26f08640f4194908cc1fa6782e75f59dc405";
  hash = "sha256-Orza8Q0mqy+LaSgF/LbGujgk0sb/1ua85WVKy0Yd9dg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
