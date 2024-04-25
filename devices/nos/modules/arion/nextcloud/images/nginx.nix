pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:ed6d2c43c8fbcd3eaa44c9dab6d94cb346234476230dc1681227aa72d07181ee";
  sha256 = "1rigpillcwf3jy3isidva008r0ix2cl14fwz2pi2nm6hm8wjqaw6";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
