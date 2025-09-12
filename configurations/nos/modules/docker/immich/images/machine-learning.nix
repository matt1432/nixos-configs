pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:a315e714c8af88894c2b711127af9c383bdaa6d213eae87273967251dff8e488";
  hash = "sha256-K4P15Bgaj0TJnwKH/oX288bLTwua/3Gp/X5xNXrg+cc=";
  finalImageName = imageName;
  finalImageTag = "release";
}
