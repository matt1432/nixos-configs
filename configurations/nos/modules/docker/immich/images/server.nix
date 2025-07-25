pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:4bfc6985eca8290bc56c4ef89a138b0ead985be31aa11f8c49ed07868b23a46c";
  hash = "sha256-afoANOsOU8rQOaZmIdx1A2tbdOnHdDP9916uGlEzRVk=";
  finalImageName = imageName;
  finalImageTag = "release";
}
