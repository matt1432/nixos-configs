pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:ab401a0f361cfad328e444838b13d5b334b189d0f556fc91a3623eb581df36df";
  hash = "sha256-7CEkOtNxG+uGiwuIvaXlYKMRxmxAZAOOfIa28xK0mDU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
