pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:c55782377718e9475e318f9a802fcff380f978331a1ae509096f97aadb971c29";
  hash = "sha256-DHTv/dyPw0YO+EghdDdtPaOM8ltxQrM9rrHo5nm06zo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
