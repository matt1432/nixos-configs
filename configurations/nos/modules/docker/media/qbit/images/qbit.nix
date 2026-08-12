pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:6816d2b144b1eb97665f886e41e18a14d026ba78c9d0953fc68a1211ea819433";
  hash = "sha256-zd+e7WmJXTSb/Ull7AR1OFWJXJfccmLSwJj77VN6VKI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
