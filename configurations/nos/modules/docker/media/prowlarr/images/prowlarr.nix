pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:2611b04166440455966b64928dbb082819f10e9ca27db56e2f234d755b767ad4";
  hash = "sha256-E04zdsSs++4m+FUHsehjPai2H4oDxI9reYq6bSl+zKI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
