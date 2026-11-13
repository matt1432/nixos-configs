pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:3d4c4545d51a690a0df15a2ff99038823a88a9822df8e794526447b9afbd7384";
  hash = "sha256-jBlHb95ksquCG6vYyP8ZPLSiNXE1WsZQjTdqxHx4thI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
