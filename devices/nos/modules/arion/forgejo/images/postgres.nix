pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:b1ae05db5c01fbca52682a6559490ddfaf9d6c6542676ed76285aa62bb92762d";
  sha256 = "0xv4b6w7lh005ns61cdwzprbxgni4rlzg7haaqq1rlz5rpir9i0q";
  finalImageName = "postgres";
  finalImageTag = "14";
}
