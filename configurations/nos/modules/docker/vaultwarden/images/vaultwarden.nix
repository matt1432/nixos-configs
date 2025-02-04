pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:24aa90c2424f2f6b10862ba84dc9141d09c1df2b7025f111c9b2bbc4c078894b";
  hash = "sha256-mlSjMr3j+BJoD3IW1t0ia5H/TDvrDVMGbSRM9r8KxTo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
