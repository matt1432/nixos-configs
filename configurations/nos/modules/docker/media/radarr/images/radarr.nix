pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:eb894bd26fd3fb29981bf91b140834417ce2ed28ab8217d0ce121db5c460f39a";
  hash = "sha256-MOu7wTQiD8SGqc3pnKkH5wfOWAck4LhP9J51oE27h+c=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
