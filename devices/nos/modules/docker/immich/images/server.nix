pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:d63feeee7a41095b3c1b18607d86a1264bcac53728a19f538a77a6e66043f492";
  sha256 = "0xlbnwcf445i949z7ai2vw0wfac7c1iapd5fsvlzz7wm29hsv1pg";
  finalImageName = imageName;
  finalImageTag = "release";
}
