pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:0d5c6da7243ce434468a67f955bbf9c12ff061307f9cc91ebd00d8f43d15772d";
  hash = "sha256-CGWHb6E//1TPDXFV4y1/j4kHQY38Sj546RIxxSHUxCs=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
