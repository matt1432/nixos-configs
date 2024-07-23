pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:05ab1728068284cbd42d54554fa2b69a3d6334adafccf2e70cf20925d7d55e90";
  sha256 = "0i2q2aaa8qn5zgvil9gbyvj6yazprvgi6z23jp0xaskkpm24qvfy";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
