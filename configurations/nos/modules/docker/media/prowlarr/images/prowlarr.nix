pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:5c9d62af19a810f7799c1d5fbf686cc6c28690c00f916c029699ae3d1c75e8ef";
  hash = "sha256-TYQgTj2ZDk3go/Q/hwn8zgmY5Jh7aAWGXmb6TkdGVmw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
