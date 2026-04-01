pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:e50f3b188a7d1771b61f395c4203e35476bd3047683508740305e830e15bacf7";
  hash = "sha256-WE4uS6myPmbOt/1EvTbrpHHNDgEMKX42jg/VxJNiIQ0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
