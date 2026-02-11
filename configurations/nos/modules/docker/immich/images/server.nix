pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:aa163d2e1cc2b16a9515dd1fef901e6f5231befad7024f093d7be1f2da14341a";
  hash = "sha256-oPp6mut/aRHSaqdKMksJ0GOLaVBtqcGIDJQsOGN7wCI=";
  finalImageName = imageName;
  finalImageTag = "release";
}
