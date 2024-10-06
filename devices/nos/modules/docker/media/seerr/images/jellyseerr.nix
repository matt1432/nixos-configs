pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:8f708df0ce3f202056bde5d7bff625eb59efe38f4ee47bdddc7560b6e4a5a214";
  sha256 = "19bppycfly5mjpj0vmj63fgkck3x4qldmqmfph05bqs1fp5n546w";
  finalImageName = imageName;
  finalImageTag = "latest";
}
