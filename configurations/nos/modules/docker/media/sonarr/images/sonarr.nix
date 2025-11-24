pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:2fc9c36769a3f50ab529e7ccc37687d118ab42199b01588573f03b3393cc3223";
  hash = "sha256-62bX99Qxyw1cTuUJ+vwYlsTDSlanev0511+HmRoWgJU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
