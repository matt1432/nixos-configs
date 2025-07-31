pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:8c9633b96ca5b748b10875a99c498ee6f1e5d7f7d1df2bf341909cacb88ad672";
  hash = "sha256-afoANOsOU8rQOaZmIdx1A2tbdOnHdDP9916uGlEzRVk=";
  finalImageName = imageName;
  finalImageTag = "release";
}
