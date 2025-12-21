pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "cyfershepard/jellystat";
  imageDigest = "sha256:e182aedd122e13be511c59f0462e0d9e48a67c7341a5f3c1f11b7aa6ab6d2291";
  hash = "sha256-O5Vd4SN5DT3rir6nFVpxqQZzjQgm4HIf8eIzy0Rtj/k=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
