pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:a484819eb60211f5299034ac80f6a681b06f89e65866ce91f356ed7c72af059c";
  sha256 = "0vqkmn70b2q8dqiiwn9y5c6ggwgnfsxcz2hyvpdirng9gbhyis4k";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
