pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:ac9fe56bee9133bcb9e27fe48faaf83c57b83d75bacc277d9b2619136632b1fe";
  hash = "sha256-TlsfPNOyZP5NF3Pv9rm7gZd3D7Fj2pznI9itYbhzdgU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
