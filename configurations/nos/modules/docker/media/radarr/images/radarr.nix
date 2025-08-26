pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:7eb64f5af8bbe48e79bc55c0c37ca8db89b2f073a9ff0094f603916ae1df9de8";
  hash = "sha256-5IlpeE+cZF2pUnpkWoaAU0cZuu7lH7fDdU+UFDjjTjg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
