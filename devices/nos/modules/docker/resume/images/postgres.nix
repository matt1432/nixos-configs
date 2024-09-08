pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:362404e4f27e4f477c6cd4a76c65f06d387b7fda2caf216e656b17bf00f9908f";
  sha256 = "1iw8qhg4lg01w6ylq8js18m640v8yvpnxabmahm8xy5anj25cw7q";
  finalImageName = "postgres";
  finalImageTag = "15-alpine";
}
