pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:3b7732505933ca591ce4a6d860cb713ad96a3176b82f7979a8dfa9973486a0d6";
  hash = "sha256-9gilDKeHi7jq4+tMtwWuTTvxGB5cnmmQOLc5+Hckhhc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
