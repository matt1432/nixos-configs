pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:ccfca8a87a65914ab23164efa1f6392940629a2a54ed71bce87049713d926426";
  hash = "sha256-gvxn7NWlAACgxuPwONVL4fKR+za5IHH9pxcbXAK2gCE=";
  finalImageName = imageName;
  finalImageTag = "release";
}
