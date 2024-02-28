pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:8420d1b03da7890f7cd21c711e520ca260cf35336aa0a794c1db6e9462dd3db1";
  sha256 = "0xv4b6w7lh005ns61cdwzprbxgni4rlzg7haaqq1rlz5rpir9i0q";
  finalImageName = "postgres";
  finalImageTag = "14";
}
