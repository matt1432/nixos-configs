pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:c960f2b52ec6542dbe6707c5a21e696a7c74fd8b17997454f4d10a55dacee133";
  hash = "sha256-RYLDckODyhP1tT4PuxSdMEmKhwXaXzhXjkzW6PNHx3I=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
