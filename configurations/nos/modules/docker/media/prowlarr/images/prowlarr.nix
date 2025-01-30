pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:b242bc98897d8fa65db7b72f5dbde04b161a092d3cce2321b8c7e62c9321820d";
  hash = "sha256-5aUjfMsTnjdH5NuqdtbQW11Y9yKSGF4f5MSJj1vPmtw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
