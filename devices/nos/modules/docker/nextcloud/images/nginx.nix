pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:0c86dddac19f2ce4fd716ac58c0fd87bf69bfd4edabfd6971fb885bafd12a00b";
  sha256 = "1l3m1p8snsqxa06b9rv398ppapnzdv20f3nl329x13r3vy1aibj6";
  finalImageName = imageName;
  finalImageTag = "latest";
}
