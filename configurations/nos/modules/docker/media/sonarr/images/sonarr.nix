pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:5c6e66c36fd0afe1323b3478b2289b5bff6e9ff17ee2c315feee29316ddb9140";
  hash = "sha256-3V7f1SWxUFFZtwFtq61wCLaCw5ehBoUmk044/mHqL6A=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
