pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:effd3d44202964c5f53af85e0fd0f2ca5287c989a43c4d55ba71133eb148bed3";
  sha256 = "19grvl67jr2sjr85pamry4v1a05mhmfl1d6bcnrbya7rkm8ly5d5";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "release";
}
