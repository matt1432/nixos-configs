pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:c716dc20f957aafd89fa9d284a2ec63e25c9e2d8d8e87c6197d540a3dce237db";
  hash = "sha256-E3N/TfbhyGIx0U2Z9wBVrDK4r5GlAHZIW6YA7f/qIKw=";
  finalImageName = imageName;
  finalImageTag = "release";
}
