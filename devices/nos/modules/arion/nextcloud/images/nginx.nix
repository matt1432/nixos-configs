pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:dff52faf7d265f2822935e8dd9ab72764763b4e716f194fb6510ba87552d6d06";
  sha256 = "0vqkmn70b2q8dqiiwn9y5c6ggwgnfsxcz2hyvpdirng9gbhyis4k";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
