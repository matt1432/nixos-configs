pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:620dc79c45816cff4f38f0b49c71f15a3bc6bab9439ba1eea3a76d23ebcf1e4d";
  sha256 = "1iw8qhg4lg01w6ylq8js18m640v8yvpnxabmahm8xy5anj25cw7q";
  finalImageName = "postgres";
  finalImageTag = "15-alpine";
}
