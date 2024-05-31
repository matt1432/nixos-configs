pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:a9513e92e7758ba3aeaf22d533c3b336bb00ee1de5e1401d4b5070ffcb9bd3f5";
  sha256 = "13fwgvjjgkh7pfimq23qn7d12cmlhr7mccjkm24ck65mn2g60gb1";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.1-fpm";
}
