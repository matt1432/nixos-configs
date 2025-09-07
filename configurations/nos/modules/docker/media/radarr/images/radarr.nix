pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:3ebb31bce86870dbcc15a5db3fba8864e302310cb2adb70476b0b64c1b3dc6dc";
  hash = "sha256-sBB3eeYfon2Yqb3rnUoacPbh+UKmyiiVVGBQDmtkvjo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
