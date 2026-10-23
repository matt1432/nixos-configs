pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:e887804fa9de4c60f5f0fb1f3a7e4febe40a8f69fe736f70c4e8589b1f868dab";
  hash = "sha256-IhmWioutss6CjsjpKpz8tkABW+oz86mliZj8PW4tP7I=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
