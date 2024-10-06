pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:db80ed8022dd15143644752a57db0553e48e23e3da54bdb9833d28ff89206a3c";
  sha256 = "0qbhjydya2bkv79hk358hrfp3lsnd75x2fqqkb6rx6yp0ywfn4nl";
  finalImageName = imageName;
  finalImageTag = "latest";
}
