pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:237e9a72c11c5350bf22e355759436ecd4fd660e820d5b556d9a9e436f25f6b9";
  sha256 = "167ix6yv6zwnwvxj0bk8x65hnf0g5z00r8yvv20pdb8d32l2naqf";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
