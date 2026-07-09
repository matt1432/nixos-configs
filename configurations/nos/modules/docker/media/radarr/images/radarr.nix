pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:28852d0eacababc206762af48fe86d78594a4f434cc46b358f9764a857098662";
  hash = "sha256-m95awrT7cMPR4UCvB17Hycn/Ucly6fQkqt8W0x7r19E=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
