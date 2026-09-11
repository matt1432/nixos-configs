pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:95ba0801df4d9d1d79d0d9a3849f656542497dab061d91b87ad4f53a71aff3ef";
  hash = "sha256-BGNtQ8ByED476QVj/qnKiJu3ZOzGOd55QwEj8wEAPLE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
