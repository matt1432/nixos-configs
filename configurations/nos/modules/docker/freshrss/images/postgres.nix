pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:c550fd3da21db9d7794aaa2365ba147842472da72601b4d9edd106ac9a800bd2";
  hash = "sha256-AWw6eoofCK2AtZjhi01xo+uaxEpXwmi0gNTfUD7A6XI=";
  finalImageName = imageName;
  finalImageTag = "14";
}
