pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:6dc11d67a4d4b086c4abf149973c97bea26d54cdbb0cf73eb4e2feb0ff780491";
  hash = "sha256-NMEnLRh00GUd4rjwT+dq64ddKNN9e0lfu6TeA1aYjyk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
