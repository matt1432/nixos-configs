pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:a5a1fdf02aa14abc33a507eafa125ff57cb83f251a519536bce331ce9e008ef7";
  sha256 = "11f700m69ji47vlz3p7g1rz9mfcgcdrkpqxi124pk8r385pkgxz3";
  finalImageName = imageName;
  finalImageTag = "latest";
}
