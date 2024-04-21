pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:f825b7d09f4645671a76310575334e09fa2585c1023c3f1b66db815db0aa14ee";
  sha256 = "0nrwj2qalgnzy2j53dyjv42aqy2v00fxzhzyxp9c50bk3wqbiv03";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.102.3";
}
