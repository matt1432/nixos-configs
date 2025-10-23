pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:029d4461bd98f124e531380505ceea2072418fdf28752aa73b7b273ba3048903";
  hash = "sha256-vqUHRfjizhf1r4FfPifNz1GbQSFTPgVY87IfsJMqlLM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
