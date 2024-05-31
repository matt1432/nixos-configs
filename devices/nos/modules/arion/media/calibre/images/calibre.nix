pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:b1a9e0b02c2cea42a67e9fabc7ee69fe4c6d0a662c2cdfb3f97428b84af65f43";
  sha256 = "0dqbvlbp9hh4pja607rfal2ggmkcsk7b0bsagx8qvjk639a92vbj";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
