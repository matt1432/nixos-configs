pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:8d48fa8c619caadfb103f04efea8747e2a2762d6c7551690919cffb987e61cee";
  hash = "sha256-QAjNiSlIzl+iAbMT1WcCOfFSr+rzckLpHaTb5xqj4Nw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
