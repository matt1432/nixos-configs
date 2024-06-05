pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:1158769d52c0ca272ced2bba4acfea3da625d5262b7321cf742dfd3d909719cf";
  sha256 = "1wpfcwhjjxl3xmv30vh6drq0da58ws0jr5j4vbfgbc0gpnh9xa19";
  finalImageName = "postgres";
  finalImageTag = "15-alpine";
}
