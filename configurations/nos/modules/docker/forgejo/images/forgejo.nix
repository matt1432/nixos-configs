pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:07d9dad5773ae40cdfc00bede6e35dce3889d22661f0f66b96999885ea5e2467";
  hash = "sha256-USWQ/1Urcdy4PdQjqAKtceVqcUgPq6puXhNh0/2wk1o=";
  finalImageName = imageName;
  finalImageTag = "12";
}
