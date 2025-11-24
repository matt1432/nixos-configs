pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:06ac318ecb95a34c7b229568dcb4271f02cb5007bb189a0dd67a2032864187ca";
  hash = "sha256-fh9tVuTnEX32dXQdq3svMU+O0xl/T6oB+1K2lk+bVD4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
