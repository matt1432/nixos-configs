pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:52ca0b18c58ec4e769b8acae9beaae37a520a365c7ead52b7fc3ba1c3352d1f0";
  hash = "sha256-jifGorzTw/2vu50SJpLDmMVSj7VoEEhcvAAnJClq7TQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
