pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:964485823771c102427a0c1cd896cf6b576add6f21bd041498b92cb040ee7270";
  hash = "sha256-tYJIQAGEKJ2pd9g8mhztP07jkblIdQvyk7wrGcFhiOA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
